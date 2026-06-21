# Pipeline Execution Results

**Pipeline Name:** pl_superstore_pipeline  
**ADF Instance:** charvi-superstore-adf  
**Resource Group:** charvi-superstore-rg  
**Region:** Central India  
**Execution Type:** Debug Run  
**Final Status:** ✅ Succeeded  

---

## All Debug Runs Summary

| Run # | Date & Time (Start) | Date & Time (End) | Duration | Status |
|---|---|---|---|---|
| Run 1 | 6/21/2026, 3:52:31 AM | 6/21/2026, 3:53:09 AM | 39s | ❌ Failed |
| Run 2 | 6/21/2026, 3:53:25 AM | 6/21/2026, 3:53:54 AM | 30s | ❌ Failed |
| Run 3 | 6/21/2026, 3:54:25 AM | 6/21/2026, 3:54:57 AM | 32s | ❌ Failed |
| Run 4 | 6/21/2026, 4:06:02 AM | 6/21/2026, 4:06:43 AM | 41s | ❌ Failed |
| Run 5 | 6/21/2026, 4:09:55 AM | 6/21/2026, 4:10:33 AM | 39s | ❌ Failed |
| Run 6 | 6/21/2026, 4:12:19 AM | 6/21/2026, 4:12:57 AM | 39s | ❌ Failed |
| **Run 7** | **6/21/2026, 4:16:01 AM** | **6/21/2026, 4:16:42 AM** | **41s** | **✅ Succeeded** |
| **Run 8** | **6/21/2026, 4:18:07 AM** | **6/21/2026, 4:18:47 AM** | **40s** | **✅ Succeeded** |

**Total Runs:** 8  
**Failed Runs:** 6  
**Successful Runs:** 2  

---

## Final Successful Run Details (Run 8)

**Pipeline Run ID:** `03d0233f-a700-4661-828e-78444a46f72c`  
**Run Start:** 6/21/2026, 4:18:07 AM  
**Run End:** 6/21/2026, 4:18:47 AM  
**Total Pipeline Duration:** 40 seconds  
**Triggered by:** Manual trigger (Debug)  
**Integration Runtime:** AutoResolveIntegrationRuntime (Central India)  

---

## Activity 1 — Get Metadata1

### Configuration
| Field | Value |
|---|---|
| Activity Type | Get Metadata |
| Dataset Used | ds_source_superstore |
| Field List Checked | Column count |
| Status | ✅ Succeeded |
| Run Start | 6/21/2026, 4:18:14 AM |
| Duration | 16 seconds |
| Integration Runtime | AutoResolveIntegrationRuntime (Central India) |

### Output (Numeric Results)
| Metric | Value | Meaning |
|---|---|---|
| **Column Count** | **21** | CSV file has exactly 21 columns — validated successfully |
| Execution Duration | 1 second | Time taken to actually read metadata |
| Queue Duration | 11 seconds | Time spent waiting for integration runtime to pick up the task |
| Activity Type (Billing) | PipelineActivity | Billed as a general pipeline activity |
| Billable Duration | 0.0167 Hours | ~1 minute of compute time billed |
| Meter Type | AzureIR | Azure Integration Runtime used |

### What Get Metadata confirmed
- ✅ Source file exists in `superstore-raw` container
- ✅ File has exactly **21 columns** matching the Superstore dataset schema
- ✅ Pipeline proceeded to Copy Data activity after successful validation

---

## Activity 2 — Copy data2

### Configuration
| Field | Value |
|---|---|
| Activity Type | Copy Data |
| Source Dataset | ds_source_superstore |
| Sink Dataset | ds_destination_superstore |
| Copy Behavior | Merge files |
| File Path Type | File path in dataset |
| Status | ✅ Succeeded |
| Run Start | 6/21/2026, 4:18:31 AM |
| Duration | 16 seconds |
| Integration Runtime | AutoResolveIntegrationRuntime (Central India) |

### Output (Numeric Results)
| Metric | Value | Meaning |
|---|---|---|
| **Rows Read** | **9,994** | All rows from source CSV successfully read |
| **Rows Copied** | **9,994** | All rows successfully written to destination |
| **Data Read** | **2,287,806 bytes (≈ 2.18 MiB)** | Total bytes read from source file |
| **Data Written** | **2,703,782 bytes (≈ 2.58 MiB)** | Total bytes written to destination file |
| **Files Read** | **1** | One source CSV file read |
| **Files Written** | **1** | One destination CSV file created |
| **Throughput** | **762.602 KB/s** | Data transfer speed |
| **Copy Duration** | **10 seconds** | Actual data transfer time |
| **Queuing Duration** | **6 seconds** | Time waiting for runtime |
| **Transfer Duration** | **3 seconds** | Time for actual file transfer |
| **Parallel Copies** | **1** | Single parallel copy used |
| **Data Integration Units** | **4** | DIU units allocated for this activity |
| **Billable Duration** | **0.0667 DIU Hours** | Compute cost unit |
| **Meter Type** | **AzureIR** | Azure Integration Runtime |
| **Errors** | **0** | No errors during copy |
| **Data Loss** | **None** | 9,994 of 9,994 rows copied (100%) |

### Source and Sink Execution Details
| Field | Source | Sink |
|---|---|---|
| Type | AzureBlobStorage | AzureBlobStorage |
| Region | Central India | Central India |
| Status | Completed | Completed |
| Peak Connections | 1 | 1 |

---

## Linked Service Details

| Field | Value |
|---|---|
| Linked Service Name | ls_blob_superstore |
| Type | Azure Blob Storage |
| Authentication Method | Account Key |
| Storage Account Connected | charvisuperstorestore |
| Connection Status | ✅ Connection Successful |
| Used By | ds_source_superstore, ds_destination_superstore |

---

## Dataset Details

### Source Dataset — ds_source_superstore
| Field | Value |
|---|---|
| Dataset Name | ds_source_superstore |
| Linked Service | ls_blob_superstore |
| Container | superstore-raw |
| File Name | Sample - Superstore.csv |
| Format | DelimitedText (CSV) |
| Column Delimiter | Comma (,) |
| Row Delimiter | Default (\r\n or \n) |
| Quote Character | Double quote (") |
| Escape Character | Double quote (") |
| First Row as Header | Yes |
| Encoding | UTF-8 |
| Total Rows | 9,994 |
| Total Columns | 21 |
| File Size | 2,287,806 bytes (≈ 2.18 MiB) |

### Destination Dataset — ds_destination_superstore
| Field | Value |
|---|---|
| Dataset Name | ds_destination_superstore |
| Linked Service | ls_blob_superstore |
| Container | superstore-processed |
| File Name | Superstore_processed.csv |
| Format | DelimitedText (CSV) |
| Copy Behavior | Merge files |
| Schema | None (auto-derived from source) |
| Output File Size | 2,703,782 bytes (≈ 2.58 MiB) |

---

## Pipeline Timeline Breakdown

| Phase | Start Time | Duration |
|---|---|---|
| Pipeline triggered | 4:18:07 AM | — |
| Get Metadata1 queuing | 4:18:14 AM | 11 seconds |
| Get Metadata1 execution | 4:18:14 AM | 1 second |
| Get Metadata1 total | 4:18:14 AM | 16 seconds |
| Copy data2 queuing | 4:18:31 AM | 6 seconds |
| Copy data2 transfer | 4:18:32 AM | 3 seconds |
| Copy data2 total | 4:18:31 AM | 16 seconds |
| Pipeline completed | 4:18:47 AM | — |
| **Total pipeline time** | — | **40 seconds** |

---

## Error Encountered and Fix Applied

| Field | Details |
|---|---|
| Error Code | DelimitedTextMoreColumnsThanDefined |
| Failure Type | User configuration issue |
| Error Message | Found more columns than expected column count 21 at row number 34 |
| Root Cause | Superstore CSV contains product names with commas inside quoted fields. Escape character was incorrectly set to Backslash (\) which caused ADF to misparse those quoted fields and count extra columns |
| Fix Applied | Changed Escape character in ds_source_superstore from Backslash (\) to Double quote (") — this correctly handles CSV fields that use double-quote escaping per RFC 4180 CSV standard |
| Runs Before Fix | 6 failed runs |
| Runs After Fix | 2 successful runs |

---

## Final Output Verification

| Item | Value |
|---|---|
| Output Container | superstore-processed |
| Output File Name | Superstore_processed.csv |
| Output File Size | 2,703,782 bytes (≈ 2.58 MiB) |
| Last Modified | 6/21/2026, 4:18:43 AM |
| Blob Type | Block blob |
| Access Tier | Hot (Inferred) |
| Rows Successfully Copied | 9,994 out of 9,994 (100%) |
| Columns | 21 |
| Data Loss | None |
| Pipeline Final Status | ✅ Succeeded |
