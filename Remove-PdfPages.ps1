<#
.SYNOPSIS
    Removes specified page numbers from a PDF file.

.DESCRIPTION
    This script uses `pdfinfo` to determine the total number of pages in the PDF,
    then uses `pdftk` to remove the listed pages and produce a new PDF.

.PARAMETER InputPdf
    The full path to the input PDF file.

.PARAMETER OutputPdf
    The full path to the output PDF file.

.PARAMETER PagesToRemove
    An array of page numbers to remove. For instance: 1,4,5

.EXAMPLE
    .\Remove-PdfPages.ps1 -InputPdf "C:\Docs\input.pdf" -OutputPdf "C:\Docs\output.pdf" -PagesToRemove 2,4,7
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$InputPdf,

    [Parameter(Mandatory = $true)]
    [string]$OutputPdf,

    [Parameter(Mandatory = $true)]
    [int[]]$PagesToRemove
)

# --- 1) Retrieve total page count using pdfinfo ---
Write-Host "`nReading total pages from '$InputPdf' ..."
# Run pdfinfo and capture output
$pdfInfoOutput = & pdfinfo "$InputPdf" 2>&1

# Attempt to extract the "Pages: X" line
$pagesLine = $pdfInfoOutput | Where-Object { $_ -match "Pages:\s+\d+" }
if (-not $pagesLine) {
    Write-Error "Could not determine page count from pdfinfo output:"
    Write-Error $pdfInfoOutput
    exit 1
}

# Extract the numeric part (total number of pages)
$totalPages = [int](([regex]"Pages:\s+(\d+)").Match($pagesLine).Groups[1].Value)
Write-Host "Total pages detected: $totalPages"

# --- 2) Prepare cat ranges for pdftk ---
# Sort the pages to remove (ensures we build valid ranges in ascending order)
$PagesToRemove = $PagesToRemove | Sort-Object

# We'll iterate from page 1 to the last page, skipping the ones in $PagesToRemove
$catRanges = New-Object System.Collections.Generic.List[string]
$lastPageKept = 1

foreach ($page in $PagesToRemove) {
    # If the page to remove is beyond our "last kept" page, form a range
    if ($page -gt $lastPageKept) {
        # Range is from lastPageKept to (page - 1)
        $range = "$lastPageKept-$($page - 1)"
        $catRanges.Add($range)
    }
    $lastPageKept = $page + 1
}

# If there's still a range left at the end, add it
if ($lastPageKept -le $totalPages) {
    $range = "$lastPageKept-$totalPages"
    $catRanges.Add($range)
}

# Join all the ranges into a single string suitable for pdftk
$catString = $catRanges -join " "
Write-Host "`nPages to be kept (pdftk syntax): $catString"

# --- 3) Run pdftk to create the output PDF without the removed pages ---
Write-Host "`nRemoving pages [$($PagesToRemove -join ', ')] from $InputPdf ..."

# Build and execute the pdftk command
$pdftkCmd = "pdftk `"$InputPdf`" cat $catString output `"$OutputPdf`""
Write-Host "Executing: $pdftkCmd"
Invoke-Expression $pdftkCmd

if (Test-Path $OutputPdf) {
    Write-Host "`nSuccessfully created '$OutputPdf'."
} else {
    Write-Error "Failed to create '$OutputPdf'."
    exit 1
}