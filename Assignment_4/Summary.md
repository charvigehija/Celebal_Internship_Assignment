# Brief Summary — Week 4 Azure Assignment

**Submitted by:** Charvi Gehija  
**Internship:** Celebal Technologies — Week 4  
**Date:** June 21, 2026  

---

## What This Assignment Was About

This assignment focused on understanding Azure cloud fundamentals and building a complete data pipeline using **Azure Blob Storage** and **Azure Data Factory (ADF)**. The goal was to move a real-world CSV dataset from a source location to a destination location using ADF's pipeline capabilities, while also learning about cloud storage, linked services, datasets, metadata validation, and access control.

---

## What I Built

A complete end-to-end cloud data pipeline that:
1. Stores a raw CSV file in Azure Blob Storage
2. Validates the file metadata before processing
3. Copies the file from a source container to a destination container
4. Runs fully automated with no manual file movement required

---

## Azure Resources Used

| Resource | Name |
|---|---|
| Resource Group | charvi-superstore-rg |
| Storage Account | charvisuperstorestore |
| Source Container | superstore-raw |
| Destination Container | superstore-processed |
| Data Factory | charvi-superstore-adf |
| Linked Service | ls_blob_superstore |
| Source Dataset | ds_source_superstore |
| Destination Dataset | ds_destination_superstore |
| Pipeline | pl_superstore_pipeline |

---

## Dataset Used

- **File:** Sample - Superstore.csv
- **Source:** Kaggle (Superstore Sales Dataset)
- **Size:** 9,994 rows × 21 columns (2.18 MiB)
- **Content:** US Superstore sales data covering orders, customers, products, regions, sales, discounts, and profits from 2014–2017

---

## Pipeline Design

The pipeline `pl_superstore_pipeline` consists of two activities connected sequentially:

```
[Get Metadata1] ──► [Copy data2]
```

- **Get Metadata1** — reads metadata of the source CSV file and validates column count before proceeding
- **Copy data2** — copies the CSV file from `superstore-raw` to `superstore-processed` container

---

## Key Results

| Metric | Value |
|---|---|
| Rows Read | 9,994 |
| Rows Copied | 9,994 (100%) |
| Data Read | 2.18 MiB |
| Data Written | 2.58 MiB |
| Copy Duration | 10 seconds |
| Total Pipeline Duration | 40 seconds |
| Pipeline Status | ✅ Succeeded |
| Output File | Superstore_processed.csv in superstore-processed |

---

## Key Concepts Learned

- **Resource Groups** — act as logical containers for all related Azure resources
- **Azure Blob Storage** — cloud object storage for unstructured data like CSV files
- **Linked Services** — saved connection strings that allow ADF to connect to external data stores
- **Datasets** — pointers to specific files or folders within a data store
- **Get Metadata Activity** — validates file properties before pipeline execution
- **Copy Data Activity** — moves data from source to destination efficiently
- **IAM Roles** — Reader, Contributor, and Storage Blob Data Contributor roles control access to Azure resources
- **Managed Identity** — allows ADF to securely access Storage without storing credentials

---

## Challenge Faced

During pipeline development, the Copy Data activity failed with a `DelimitedTextMoreColumnsThanDefined` error because some product names in the Superstore CSV contained commas inside quoted fields. The fix was to change the Escape character setting from Backslash to Double quote in the source dataset, which allowed ADF to correctly parse all 9,994 rows without errors.

---

## Final Outcome

The pipeline successfully copied all **9,994 rows** of Superstore sales data from the source container to the destination container in **40 seconds**, with zero data loss and both activities completing with **Succeeded** status. The output file `Superstore_processed.csv` (2.58 MiB) is now available in the `superstore-processed` Blob container, ready for further analysis or processing.
