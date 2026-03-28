#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

/**
 * Script to extract common session files from two zip archives
 * Creates separate zip files for each matched phone number
 */

const SELLER_ZIP = 'seller1.zip';
const BUYER_ZIP = 'buyer_report.zip';
const TEMP_DIR = path.join(__dirname, 'temp_extraction');
const OUTPUT_DIR = path.join(__dirname, 'matched_sessions');

// Create temporary and output directories
function setupDirectories() {
    if (fs.existsSync(TEMP_DIR)) {
        fs.rmSync(TEMP_DIR, { recursive: true, force: true });
    }
    if (!fs.existsSync(OUTPUT_DIR)) {
        fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    }
    fs.mkdirSync(TEMP_DIR, { recursive: true });
}

// Extract zip file to a directory
function extractZip(zipPath, outputPath) {
    console.log(`Extracting ${zipPath}...`);
    try {
        execSync(`unzip -q "${zipPath}" -d "${outputPath}"`);
    } catch (error) {
        console.error(`Failed to extract ${zipPath}: ${error.message}`);
        throw error;
    }
}

// Get list of phone numbers from a directory
function getPhoneNumbers(dir) {
    const files = fs.readdirSync(dir);
    const phoneNumbers = new Set();
    
    files.forEach(file => {
        if (file.endsWith('.json') && file.startsWith('+')) {
            // Remove '+' prefix and '.json' suffix
            const phoneNumber = file.substring(1, file.length - 5);
            phoneNumbers.add(phoneNumber);
        }
    });
    
    return Array.from(phoneNumbers).sort();
}

// Find common phone numbers between two arrays
function findCommonNumbers(seller1Numbers, buyerNumbers) {
    // Use Set for O(n) lookup instead of O(n²) with includes
    const buyerSet = new Set(buyerNumbers);
    const commonNumbers = seller1Numbers.filter(num => buyerSet.has(num));
    return commonNumbers;
}

// Check if a directory exists in the extracted folder
function getTdataPath(extractedDir, phoneNumber) {
    // Check for directory without '+' prefix
    const dirPath = path.join(extractedDir, phoneNumber);
    if (fs.existsSync(dirPath)) {
        const tdataPath = path.join(dirPath, 'tdata');
        if (fs.existsSync(tdataPath)) {
            return dirPath;
        }
    }
    return null;
}

// Create a zip file for a matched phone number
function createMatchedZip(phoneNumber, seller1Dir, buyerDir) {
    console.log(`Creating zip for +${phoneNumber}...`);
    
    const zipName = `+${phoneNumber}_matched.zip`;
    const zipPath = path.join(OUTPUT_DIR, zipName);
    
    // Collect files to include
    const filesToZip = [];
    
    // From seller1: .json and .session files
    const seller1Json = path.join(seller1Dir, `+${phoneNumber}.json`);
    const seller1Session = path.join(seller1Dir, `+${phoneNumber}.session`);
    
    if (fs.existsSync(seller1Json)) {
        filesToZip.push({ source: seller1Json, dest: `seller1_+${phoneNumber}.json` });
    }
    if (fs.existsSync(seller1Session)) {
        filesToZip.push({ source: seller1Session, dest: `seller1_+${phoneNumber}.session` });
    }
    
    // From buyer_report: .json, .session, and tdata if exists
    const buyerJson = path.join(buyerDir, `+${phoneNumber}.json`);
    const buyerSession = path.join(buyerDir, `+${phoneNumber}.session`);
    const buyerTdataDir = getTdataPath(buyerDir, phoneNumber);
    
    if (fs.existsSync(buyerJson)) {
        filesToZip.push({ source: buyerJson, dest: `buyer_+${phoneNumber}.json` });
    }
    if (fs.existsSync(buyerSession)) {
        filesToZip.push({ source: buyerSession, dest: `buyer_+${phoneNumber}.session` });
    }
    
    // Create a temporary directory for this zip
    const tempZipDir = path.join(TEMP_DIR, `zip_${phoneNumber}`);
    fs.mkdirSync(tempZipDir, { recursive: true });
    
    // Copy files to temp directory
    filesToZip.forEach(file => {
        const destPath = path.join(tempZipDir, file.dest);
        fs.copyFileSync(file.source, destPath);
    });
    
    // If tdata directory exists, copy it
    if (buyerTdataDir) {
        const tdataDestPath = path.join(tempZipDir, `buyer_${phoneNumber}_tdata`);
        copyDirectory(path.join(buyerTdataDir, 'tdata'), tdataDestPath);
    }
    
    // Create zip file
    try {
        // Use -C option or cd in a subshell to avoid changing process directory
        execSync(`cd "${tempZipDir}" && zip -r "${zipPath}" .`);
    } catch (error) {
        console.error(`Failed to create zip file for +${phoneNumber}: ${error.message}`);
        throw error;
    }
    
    // Clean up temp directory for this zip
    fs.rmSync(tempZipDir, { recursive: true, force: true });
    
    console.log(`Created ${zipName}`);
}

// Recursively copy directory
function copyDirectory(source, destination) {
    if (!fs.existsSync(destination)) {
        fs.mkdirSync(destination, { recursive: true });
    }
    
    const entries = fs.readdirSync(source, { withFileTypes: true });
    
    for (const entry of entries) {
        const srcPath = path.join(source, entry.name);
        const destPath = path.join(destination, entry.name);
        
        if (entry.isDirectory()) {
            copyDirectory(srcPath, destPath);
        } else {
            fs.copyFileSync(srcPath, destPath);
        }
    }
}

// Main execution
function main() {
    console.log('=== Session File Matcher ===\n');
    
    // Check if input files exist
    if (!fs.existsSync(SELLER_ZIP)) {
        console.error(`Error: ${SELLER_ZIP} not found`);
        process.exit(1);
    }
    if (!fs.existsSync(BUYER_ZIP)) {
        console.error(`Error: ${BUYER_ZIP} not found`);
        process.exit(1);
    }
    
    // Setup directories
    setupDirectories();
    
    // Extract both zip files
    const seller1ExtractDir = path.join(TEMP_DIR, 'seller1');
    const buyerExtractDir = path.join(TEMP_DIR, 'buyer');
    
    fs.mkdirSync(seller1ExtractDir, { recursive: true });
    fs.mkdirSync(buyerExtractDir, { recursive: true });
    
    extractZip(SELLER_ZIP, seller1ExtractDir);
    extractZip(BUYER_ZIP, buyerExtractDir);
    
    // Get phone numbers from both extracts
    console.log('\nAnalyzing phone numbers...');
    const seller1Numbers = getPhoneNumbers(seller1ExtractDir);
    const buyerNumbers = getPhoneNumbers(buyerExtractDir);
    
    console.log(`Seller1 has ${seller1Numbers.length} phone numbers`);
    console.log(`Buyer report has ${buyerNumbers.length} phone numbers`);
    
    // Find common numbers
    const commonNumbers = findCommonNumbers(seller1Numbers, buyerNumbers);
    console.log(`Found ${commonNumbers.length} common phone numbers\n`);
    
    if (commonNumbers.length === 0) {
        console.log('No common phone numbers found. Exiting.');
        fs.rmSync(TEMP_DIR, { recursive: true, force: true });
        return;
    }
    
    // Create zip files for each common number
    console.log('Creating matched zip files...\n');
    commonNumbers.forEach(phoneNumber => {
        createMatchedZip(phoneNumber, seller1ExtractDir, buyerExtractDir);
    });
    
    // Clean up temp directory
    console.log('\nCleaning up temporary files...');
    fs.rmSync(TEMP_DIR, { recursive: true, force: true });
    
    console.log(`\n=== Complete ===`);
    console.log(`Created ${commonNumbers.length} matched session zip files in '${OUTPUT_DIR}' directory`);
}

// Run the script
main();
