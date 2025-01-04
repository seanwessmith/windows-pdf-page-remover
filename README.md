# Remove-PdfPages.ps1

## Overview

**Remove-PdfPages.ps1** is a PowerShell script designed to remove specified pages from a PDF file. By providing an array of page numbers to exclude, the script generates a new PDF without those pages. This tool is particularly useful for automating PDF modifications in Windows environments.

## Table of Contents

- [Remove-PdfPages.ps1](#remove-pdfpagesps1)
  - [Overview](#overview)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Prerequisites](#prerequisites)
    - [Installing Dependencies](#installing-dependencies)
  - [Installation](#installation)

## Features

- **Selective Page Removal:** Easily remove one or multiple pages from a PDF.
- **Automated Processing:** Streamline PDF editing tasks with scripting.
- **Compatibility:** Works with any PDF file accessible via the script.
- **Efficient Handling:** Suitable for PDFs with a large number of pages.

## Prerequisites

Before using the script, ensure that the following tools are installed and accessible in your system's `PATH`:

1. **PowerShell 5.0 or higher:** Comes pre-installed on modern Windows systems.
2. **pdfinfo:** Part of the [Xpdf](https://www.xpdfreader.com/download.html) or [Poppler](https://poppler.freedesktop.org/) utilities.
3. **pdftk:** Available for download at [PDF Labs](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/).

### Installing Dependencies

- **pdfinfo:**
  - Download the appropriate package for your system from the [Xpdf](https://www.xpdfreader.com/download.html) or [Poppler](https://poppler.freedesktop.org/) website.
  - Extract the executable and add its directory to your system's `PATH`.

- **pdftk:**
  - Download the installer or portable version from the [PDF Labs](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) website.
  - Install it or extract the executable and ensure it's accessible via `PATH`.

## Installation

1. **Download the Script:**
   
   Save the `Remove-PdfPages.ps1` script to a directory of your choice, e.g., `C:\Scripts\`.

2. **Verify Dependencies:**

   Open PowerShell and run the following commands to ensure `pdfinfo` and `pdftk` are accessible:

   ```powershell
   pdfinfo -v
   pdftk --version