# Week 4 Assignment — Azure Cloud Fundamentals and Data Pipeline Implementation using ADF

**Internship:** Celebal Technologies  
**Week:** 4  
**Submitted by:** Charvi Gehija  
**Email:** charvi.techy@gmail.com  
**Date:** June 21, 2026  

---

## Objective

Understand core Azure cloud concepts and build a complete end-to-end data pipeline using Azure Blob Storage and Azure Data Factory (ADF). The pipeline reads a CSV file from a source Blob container, validates its metadata, and copies it to a destination Blob container.

---

## Dataset Used

**Name:** Superstore Sales Dataset  
**Source:** Kaggle — vivek468/superstore-dataset-final  
**File:** `Sample - Superstore.csv`  
**Size:** 9,994 rows × 21 columns (~2.18 MiB)  
**Description:** Sales data of a US-based Superstore covering orders from January 2014 to December 2017, including customer segments, product categories, regions, sales, discounts, and profit values.

---

## Azure Resources Created

| Resource | Name | Type | Region |
|---|---|---|---|
| Resource Group | charvi-superstore-rg | Resource Group | Central India |
| Storage Account | charvisuperstorestore | Storage Account (LRS) | Central India |
| Source Container | superstore-raw | Blob Container | — |
| Destination Container | superstore-processed | Blob Container | — |
| Data Factory | charvi-superstore-adf | Data Factory V2 | Central India |
| Linked Service | ls_blob_superstore | Azure Blob Storage | — |
| Source Dataset | ds_source_superstore | DelimitedText (CSV) | — |
| Destination Dataset | ds_destination_superstore | DelimitedText (CSV) | — |
| Pipeline | pl_superstore_pipeline | ADF Pipeline | — |

---

## Task-wise Summary

### Task 1 — Explore Azure Portal + Create Resource Group
- Logged into Azure Portal and explored the UI including the search bar, left sidebar, and home screen
- Created Resource Group `charvi-superstore-rg` in the **Central India** region under the **Azure for Students** subscription
- 📸 Screenshot: `Screenshots/01_resource_group.png`

---

### Task 2 — Storage Setup
- Created Storage Account `charvisuperstorestore` with Standard performance and Locally Redundant Storage (LRS)
- Created two Blob Containers:
  - `superstore-raw` — source container for the input CSV file
  - `superstore-processed` — destination container for the copied output file
- Uploaded `Sample - Superstore.csv` (2.18 MiB) into the `superstore-raw` container
- 📸 Screenshots: `Screenshots/02_storage_account.png`, `Screenshots/03_containers.png`, `Screenshots/04_csv_uploaded_superstore_raw.png`

---

### Task 3 — ADF Basics
- Created Azure Data Factory instance `charvi-superstore-adf` (V2) in Central India
- Launched ADF Studio and explored the three main tabs:
  - **Author** — for building pipelines, datasets, and linked services
  - **Monitor** — for tracking pipeline run results
  - **Manage** — for managing linked services and integration runtimes
- Created Linked Service `ls_blob_superstore` connecting ADF to the Storage Account using Account Key authentication — connection tested successfully
- Created two Datasets:
  - `ds_source_superstore` — points to `Sample - Superstore.csv` in `superstore-raw`
  - `ds_destination_superstore` — points to `Superstore_processed.csv` in `superstore-processed`
- Added a **Get Metadata** activity to validate the source file before copying — ran successfully and confirmed column count
- 📸 Screenshots: `Screenshots/05_linked_service.png`, `Screenshots/06_datasets.png`, `Screenshots/07_get_metadata_succeeded.png`

---

### Task 4 — Pipeline Development
- Built pipeline `pl_superstore_pipeline` containing two connected activities:
  1. **Get Metadata1** — validates the source CSV file (checks column count)
  2. **Copy data2** — copies the CSV from `superstore-raw` to `superstore-processed`
- Activities connected sequentially: Get Metadata runs first, then Copy Data runs after success
- Source configured with File path in dataset pointing to `Sample - Superstore.csv`
- Sink configured with `ds_destination_superstore`, Copy behavior set to Merge files
- 📸 Screenshot: `Screenshots/08_pipeline_design.png`

---

### Task 5 — Pipeline Execution
- Ran the pipeline using **Debug** mode
- Both activities completed successfully:
  - Get Metadata1 → ✅ Succeeded (16 seconds)
  - Copy data2 → ✅ Succeeded (16 seconds)
- Total pipeline duration: **40 seconds**
- Pipeline run ID: `03d0233f-a700-4661-828e-78444a46f72c`
- 📸 Screenshot: `Screenshots/09_pipeline_execution_succeeded.png`

---

### Task 6 — IAM Roles
- Assigned the following roles on **Resource Group** `charvi-superstore-rg`:
  - **Reader** — Charvi Gehija (User)
  - **Contributor** — Charvi Gehija (User)
- Assigned the following role on **Storage Account** `charvisuperstorestore`:
  - **Storage Blob Data Contributor** — `charvi-superstore-adf` (Managed Identity)
  - This gives ADF official authorization to read from and write to Blob Storage
- 📸 Screenshots: `Screenshots/10_iam_roles_resource_group.png`, `Screenshots/11_iam_roles_storage_account.png`

---

### Mini Project — End-to-End Pipeline
- Built a complete pipeline that:
  1. Reads `Sample - Superstore.csv` from `superstore-raw` Blob container
  2. Validates file metadata using Get Metadata activity
  3. Copies the data to `superstore-processed` Blob container as `Superstore_processed.csv`
- Output file `Superstore_processed.csv` (2.58 MiB) successfully created in the destination container
- Pipeline executed successfully with both activities showing Succeeded status
- 📸 Screenshot: `Screenshots/12_destination_container_output.png`

---

## Pipeline Execution Results

| Run | Date & Time | Duration | Status |
|---|---|---|---|
| Debug Run 1 | 6/21/2026, 3:52:31 AM | 39s | ❌ Failed |
| Debug Run 2 | 6/21/2026, 3:53:25 AM | 30s | ❌ Failed |
| Debug Run 3 | 6/21/2026, 3:54:25 AM | 32s | ❌ Failed |
| Debug Run 4 | 6/21/2026, 4:06:02 AM | 41s | ❌ Failed |
| Debug Run 5 | 6/21/2026, 4:09:55 AM | 39s | ❌ Failed |
| Debug Run 6 | 6/21/2026, 4:12:19 AM | 39s | ❌ Failed |
| **Debug Run 7** | **6/21/2026, 4:16:01 AM** | **41s** | **✅ Succeeded** |
| **Debug Run 8** | **6/21/2026, 4:18:07 AM** | **40s** | **✅ Succeeded** |

### Error Encountered and Fix Applied
**Error:** `DelimitedTextMoreColumnsThanDefined` — ADF found more columns than the expected 21 at row 34 of the CSV.  
**Root Cause:** Some product names in the Superstore CSV contain commas inside quoted fields. The Escape character was set to Backslash (`\`) but the CSV uses Double quote (`"`) as the escape character.  
**Fix Applied:** Changed the Escape character setting in `ds_source_superstore` from Backslash to Double quote — this allowed ADF to correctly parse all quoted fields containing commas.

---

## Final Output

| Item | Details |
|---|---|
| Source file | `Sample - Superstore.csv` (2.18 MiB) in `superstore-raw` |
| Destination file | `Superstore_processed.csv` (2.58 MiB) in `superstore-processed` |
| Pipeline status | ✅ Succeeded |
| Execution time | 40 seconds |
| Activities | Get Metadata + Copy Data — both Succeeded |
| Integration runtime | AutoResolveIntegrationRuntime (Central India) |

---

## Screenshots Index

| # | File | Description |
|---|---|---|
| 01 | `01_resource_group.png` | Resource Group charvi-superstore-rg overview |
| 02 | `02_storage_account.png` | Storage Account charvisuperstorestore overview |
| 03 | `03_containers.png` | Both Blob containers listed |
| 04 | `04_csv_uploaded_superstore_raw.png` | CSV file uploaded in superstore-raw |
| 05 | `05_linked_service.png` | Linked Service ls_blob_superstore |
| 06 | `06_datasets.png` | Both datasets listed in ADF |
| 07 | `07_get_metadata_succeeded.png` | Get Metadata activity succeeded |
| 08 | `08_pipeline_design.png` | Pipeline canvas design |
| 09 | `09_pipeline_execution_succeeded.png` | Pipeline execution succeeded |
| 10 | `10_iam_roles_resource_group.png` | IAM roles on Resource Group |
| 11 | `11_iam_roles_storage_account.png` | IAM roles on Storage Account |
| 12 | `12_destination_container_output.png` | Output file in superstore-processed |
