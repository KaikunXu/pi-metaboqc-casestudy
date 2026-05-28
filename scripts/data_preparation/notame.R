# ==============================================================================
# Function: extract_and_standardize_rda (R Implementation)
# Description: Extracts intensity and metadata from notame S4 objects, strictly
#              retains only 5 standard columns (Sample Name, Inject Order, 
#              Bio Group, Sample Type, Batch), deletes all other metadata columns,
#              and returns tidymass-compatible tibbles with space-normalized names.
# ==============================================================================

extract_and_standardize_rda <- function(rda_name) {
  
  if (!file.exists(rda_name)) stop(sprintf("File not found: %s", rda_name))
  
  # Load required packages for S4 parsing and tidy data structures
  suppressPackageStartupMessages(library(SummarizedExperiment))
  suppressPackageStartupMessages(library(Biobase))
  suppressPackageStartupMessages(library(tibble))
  
  message(sprintf("[INFO] Loading and parsing %s...", rda_name))
  loaded_objects <- load(rda_name)
  target_data <- get(loaded_objects[1])
  
  # 1. Extract raw matrices based on S4 Class
  if (inherits(target_data, "SummarizedExperiment")) {
    raw_intensity <- assay(target_data)
    raw_metadata <- colData(target_data)
  } else {
    raw_intensity <- exprs(target_data)
    raw_metadata <- pData(target_data)
  }
  
  raw_intensity[raw_intensity == 0] <- NA
  
  message("[INFO] Extracting and refactoring specific metadata columns...")
  
  # ============================================================================
  # Phase A: Metadata Refactoring and Strict Extraction
  # ============================================================================
  meta_df <- as.data.frame(raw_metadata)
  
  # Convert underscores to spaces in Sample IDs (rownames)
  clean_sample_names <- gsub("_", " ", rownames(meta_df))
  rownames(meta_df) <- clean_sample_names
  
  # Map and rename existing columns based on keywords
  cnames <- tolower(colnames(meta_df))
  new_cnames <- colnames(meta_df)
  
  for (i in seq_along(cnames)) {
    if (grepl("batch", cnames[i])) {
      new_cnames[i] <- "Batch"
    } else if (grepl("order", cnames[i])) {
      new_cnames[i] <- "Inject Order"
    } else if (grepl("group", cnames[i])) {
      # Rename 'Group' to 'Bio Group' as requested
      new_cnames[i] <- "Bio Group"
    } else if (grepl("qc", cnames[i]) || cnames[i] == "class" || grepl("type", cnames[i])) {
      # Rename 'QC' or 'Class' to 'Sample Type' as requested
      new_cnames[i] <- "Sample Type"
    } else {
      # Mark other columns for deletion by keeping their original names temporarily
      new_cnames[i] <- colnames(meta_df)[i]
    }
  }
  colnames(meta_df) <- new_cnames
  
  # Explicitly bind the "Sample Name" column from cleaned rownames
  meta_df <- cbind(`Sample Name` = clean_sample_names, meta_df)
  
  # Define the strict whitelist of columns to keep
  target_columns <- c("Sample Name", "Inject Order", "Bio Group", "Sample Type", "Batch")
  
  # Keep only the columns that exist in the target whitelist (deletes all others)
  available_columns <- target_columns[target_columns %in% colnames(meta_df)]
  meta_df <- meta_df[, available_columns, drop = FALSE]
  
  # Standardize the values inside "Sample Type" to match pipeline logic
  if ("Sample Type" %in% colnames(meta_df)) {
    st <- as.character(meta_df[["Sample Type"]])
    st[tolower(st) == "subject" | tolower(st) == "true sample" | tolower(st) == "sample"] <- "Sample"
    st[tolower(st) == "qc"] <- "QC"
    st[tolower(st) == "blank"] <- "Blank"
    meta_df[["Sample Type"]] <- st
  }
  
  # Standardize Batch values (e.g., "Batch 1" -> "Batch-1")
  if ("Batch" %in% colnames(meta_df)) {
    meta_df[["Batch"]] <- paste0("Batch-", gsub("(?i)Batch[-_\\s]?", "", meta_df[["Batch"]]))
  }
  
  # NEW: Replace "QC" with "Invalid" in the "Bio Group" column
  if ("Bio Group" %in% colnames(meta_df)) {
    # Extract the column as character vector to avoid factor-level issues
    bg <- as.character(meta_df[["Bio Group"]])
    
    # Use case-insensitive matching to find 'qc' and replace with 'Invalid'
    bg[tolower(bg) == "qc"] <- "Invalid"
    
    # Reassign the updated values back to the data frame
    meta_df[["Bio Group"]] <- bg
  }
  
  # Convert the strictly filtered metadata data.frame to a tibble
  meta_tibble <- tibble::as_tibble(meta_df)
  
  # ============================================================================
  # Phase B: Intensity Matrix Standardization
  # ============================================================================
  intensity_df <- as.data.frame(raw_intensity)
  
  # Ensure column names (Sample IDs) match the cleaned version with spaces
  colnames(intensity_df) <- clean_sample_names
  
  # Convert underscores in Metabolite/Feature IDs to spaces
  clean_metabolites <- gsub("_", " ", rownames(intensity_df))
  
  # Explicitly add the "Metabolite" column
  intensity_df <- cbind(Metabolite = clean_metabolites, intensity_df)
  
  # Convert the intensity matrix to a tibble
  intensity_tibble <- tibble::as_tibble(intensity_df)
  
  # ============================================================================
  # Phase C: Final Return
  # ============================================================================
  message("[SUCCESS] Metadata columns strictly filtered and converted to tibbles.")
  return(list(intensity = intensity_tibble, meta = meta_tibble))
}

process_and_export_rda <- function(rda_name, input_dir, output_dir) {
  
  # 1. Construct the full absolute path to the input RDA file
  rda_file_path <- file.path(input_dir, paste0(rda_name, ".rda"))
  
  # Defensive check: ensure the file actually exists before processing
  if (!file.exists(rda_file_path)) {
    warning(sprintf("[WARN] File not found, skipping: %s", rda_file_path))
    return(invisible(FALSE)) # Return silently
  }
  
  message(sprintf("\n[INFO] =================================================="))
  message(sprintf("[INFO] Processing dataset: %s", rda_name))
  
  # 2. Call the core extraction and standardization function 
  # (Assumes extract_and_standardize_rda() is loaded in your environment)
  result_list <- extract_and_standardize_rda(rda_name = rda_file_path)
  
  # Unpack the results
  intensity_tibble <- result_list$intensity
  meta_tibble      <- result_list$meta
  
  # 3. Construct dynamic output filenames
  out_intensity_file <- normalizePath(
    file.path( output_dir, paste0("project_intensity.csv")),
    mustWork = FALSE)
  out_meta_file      <- normalizePath(
    file.path(output_dir, paste0("project_meta.csv")),
    mustWork = FALSE)
  
  # 4. Export to CSV using readr
  readr::write_csv(intensity_tibble, file = out_intensity_file)
  message(sprintf(
    "[SUCCESS] Exported '%s' intensity file to processed directory: '%s'.",
    rda_name, out_intensity_file))
  
  readr::write_csv(meta_tibble, file = out_meta_file)
  message(sprintf(
    "[SUCCESS] Exported '%s' meta file to processed directory: '%s'.",
    rda_name, out_meta_file))
  
  return(invisible(TRUE))
}

# ==============================================================================
# Batch Execution Pipeline (The Main Script)
# ==============================================================================
# 1. Define base directories (Calculated ONCE for performance)
script_dir <- dirname(this.path::this.path())

input_dir <- normalizePath(
  file.path(script_dir, "..", "..", "data", "raw", "notame"), 
  mustWork = FALSE)

output_dir <- normalizePath(
  file.path(script_dir, "..", "..", "data", "processed", "notame"), 
  mustWork = FALSE)
# Safely create the output directory if it doesn't exist
dir.create(path = output_dir, recursive = TRUE, showWarnings = FALSE)

# 2. Define the list of datasets to process
ds_name <- "toy_notame_set"
# "hilic_neg_sample", "hilic_pos_sample", "rp_neg_sample", "rp_pos_sample"

# 3. Execute the batch processing using a loop
process_and_export_rda(
  rda_name   = ds_name,
  input_dir  = input_dir,
  output_dir = output_dir)

message("\n[INFO] DATASETS PROCESSED AND EXPORTED SUCCESSFULLY! 🎉")
