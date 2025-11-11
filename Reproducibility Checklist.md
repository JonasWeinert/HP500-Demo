# Research Reproducibility Package Checklist

## Essential Components

### ✓ Documentation: README File
**What it is:** A comprehensive README that serves as the entry point for understanding your project

**Tips:**
- **Stata/R/Python:** Include project title, authors, date, and brief description
- **Stata:** Note Stata version required (e.g., "Stata 17 or higher")
- **R:** Specify R version (e.g., "R 4.3.0+")
- **Python:** Specify Python version (e.g., "Python 3.9+")
- Document hardware/OS requirements if analyses are computationally intensive
- Provide estimated runtime for full reproduction
- List all data sources with access instructions (URLs, application procedures, IRB protocols)
- Include a "Quick Start" section with numbered steps to reproduce results
- Document any manual steps that cannot be automated (e.g., data requests, license agreements)

---

### ✓ Folder Structure: Clear and Modular Organization
**What it is:** A logical directory structure that separates inputs, code, and outputs

**Recommended structure:**
```
project/
├── README.md
├── code/
│   ├── 00_master.do / main.R / main.py
│   ├── 01_clean/
│   ├── 02_analysis/
│   └── 03_figures_tables/
├── data/
│   ├── raw/          (read-only)
│   └── processed/
├── output/
│   ├── figures/
│   ├── tables/
│   └── logs/
└── documentation/
```

**Tips:**
- Keep raw data in a separate, unmodified folder
- Use numbered prefixes (01_, 02_) to indicate execution order
- **Stata:** Store ado files in `code/ado/` and set adopath in master script
- **R:** Consider using an RStudio Project (.Rproj) file
- **Python:** Include an empty `__init__.py` in code folders if treating as package

---

### ✓ File Paths: Centralized Settings, Relative Paths
**What it is:** All file paths defined in one place and use relative (not absolute) paths

**Tips:**
- **Stata:**
```stata
* In master script:
global root "/path/to/project"  // Only absolute path needed
global data "$root/data"
global code "$root/code"
global output "$root/output"

* In other scripts:
use "$data/raw/dataset.dta", clear
```

- **R:**
```r
# Option 1: Use here package
library(here)
data <- read.csv(here("data", "raw", "dataset.csv"))

# Option 2: Set root in master script
root <- getwd()  # Or use dirname(rstudioapi::getActiveDocumentContext()$path)
data_path <- file.path(root, "data", "raw")
```

- **Python:**
```python
# Use pathlib for cross-platform compatibility
from pathlib import Path

ROOT = Path(__file__).parent.parent  # Adjust levels as needed
DATA_RAW = ROOT / "data" / "raw"
OUTPUT = ROOT / "output"

# Or use os.path
import os
ROOT = os.path.dirname(os.path.abspath(__file__))
```

- Never use hardcoded paths like `"C:/Users/YourName/Documents/..."`
- Use forward slashes (/) or proper path functions to ensure cross-platform compatibility

---

### ✓ Outputs: All Generated via Code
**What it is:** Every table, figure, and output file is produced by code, not manually

**Tips:**
- Export all regression tables programmatically
  - **Stata:** Use `esttab`, `outreg2`, or `putexcel`
  - **R:** Use `stargazer`, `modelsummary`, `gt`, or `kable`
  - **Python:** Use `stargazer`, `pandas.to_latex()`, or `dataframe.to_excel()`
  
- Save all figures with code
  - **Stata:** `graph export "$output/figures/fig1.png", replace`
  - **R:** `ggsave(here("output", "figures", "fig1.png"))`
  - **Python:** `plt.savefig(OUTPUT / "figures" / "fig1.png")`
  
- Include code comments indicating which output file each section produces
- Name output files descriptively (e.g., `table1_summary_stats.tex`, not `table1.tex`)
- Use version control for code, not for generated outputs (add output/ to .gitignore)

---

### ✓ Randomness: Set Seeds for Reproducibility
**What it is:** If any analysis involves randomness, set a seed for exact replication

**Tips:**
- **Stata:**
```stata
set seed 12345
set sortseed 12345  // Also set for sort operations
```

- **R:**
```r
set.seed(12345)
# For parallel processing:
library(doRNG)
registerDoRNG(12345)
```

- **Python:**
```python
import random
import numpy as np

random.seed(12345)
np.random.seed(12345)

# For neural networks/deep learning:
import tensorflow as tf
tf.random.set_seed(12345)
```

- Document the seed value in your README
- Set seed at the beginning of each script that uses randomness
- Be aware that different software versions may produce different results even with same seed

---

### ✓ File Setup: Master Script with Hierarchical Execution
**What it is:** One master script that runs all analyses in order

**Tips:**
- **Stata:**
```stata
// 00_master.do
clear all
set more off

// Set paths
global root "C:/project"  // User changes only this line
global code "$root/code"
// ... other globals

// Run all scripts
do "$code/01_clean/clean_data.do"
do "$code/02_analysis/regressions.do"
do "$code/03_figures_tables/make_tables.do"
```

- **R:**
```r
# 00_master.R
rm(list = ls())

# Source all scripts
source(here("code", "01_clean", "clean_data.R"))
source(here("code", "02_analysis", "regressions.R"))
source(here("code", "03_figures_tables", "make_tables.R"))
```

- **Python:**
```python
# main.py
import subprocess
import sys

scripts = [
    "code/01_clean/clean_data.py",
    "code/02_analysis/regressions.py",
    "code/03_figures_tables/make_tables.py"
]

for script in scripts:
    print(f"\n{'='*50}\nRunning {script}\n{'='*50}")
    subprocess.run([sys.executable, script], check=True)
```

- Name scripts descriptively and number them in execution order
- Each script should be runnable independently (after prerequisites)
- Include estimated runtime comments for long-running scripts
- **Stata:** Use `capture log close` and `log using` to save logs
- **R/Python:** Consider using logging libraries

---

### ✓ Packages: Specify Versions
**What it is:** Document exact package versions to ensure consistency

**Tips:**
- **Stata:**
```stata
// In master script or separate requirements.do
adopath + "$code/ado"  // For custom ados

// Document required packages in README:
// - estout (ssc install estout)
// - reghdfe (ssc install reghdfe)
// Stata version: 17.0

// Check versions:
which reghdfe
```

- **R:**
```r
# Use renv for dependency management
install.packages("renv")
renv::init()      # Initialize project
renv::snapshot()  # Save package versions
# Replicator runs: renv::restore()

# Or manually document in README with sessionInfo()
sessionInfo()
```

- **Python:**
```python
# Create requirements.txt:
# pip freeze > requirements.txt

# Or use conda environment:
# conda env export > environment.yml

# Include in requirements.txt:
pandas==2.0.3
numpy==1.24.3
scipy==1.11.1
matplotlib==3.7.2
```

- Commit `renv.lock` (R) or `requirements.txt`/`environment.yml` (Python) to version control
- **Stata:** For version-specific code, use `version 17:` command
- Provide installation instructions in README

---

## Recommended Components

### ✓ Style: Readable Spacing
**What it is:** Use whitespace to make code visually scannable

**Tips:**
- Use blank lines to separate logical sections
- Align similar operations vertically:

**Stata:**
```stata
gen     age_squared = age^2
gen     income_log  = log(income)
replace education   = . if education < 0
```

**R:**
```r
# Use consistent spacing around operators
result <- model %>%
  filter(year >= 2010) %>%
  mutate(
    age_squared = age^2,
    income_log  = log(income)
  ) %>%
  summarize(mean_income = mean(income))
```

**Python:**
```python
# Follow PEP 8 style guide
df['age_squared'] = df['age']**2
df['income_log']  = np.log(df['income'])
df['education']   = df['education'].replace(-999, np.nan)
```

- Limit line length (80-100 characters)
- Use consistent indentation (4 spaces recommended)
- Add blank lines before comments

---

### ✓ Annotations: Granular Code Comments
**What it is:** Clear comments explaining what code does and why

**Tips:**
- Explain *why* not just *what*:
```stata
* Drop observations with missing outcome (needed for balanced panel)
drop if missing(outcome)

* Keep only treated states (control states analyzed separately in extension)
keep if treated == 1
```

- Document data transformations:
```r
# Winsorize income at 1st and 99th percentiles to reduce outlier influence
# Following Smith et al. (2020) methodology
df <- df %>%
  mutate(income_winsor = Winsorize(income, probs = c(0.01, 0.99)))
```

- Use headers for major sections:
```python
# ============================================================
# SECTION 2: DATA CLEANING AND VARIABLE CONSTRUCTION
# ============================================================
```

- Document non-obvious choices or arbitrary thresholds
- **Stata:** Use `//` for inline comments, `*` for full-line comments
- Reference papers or documentation for complex methods

---

### ✓ Modularity: Functions and Loops
**What it is:** Avoid repetitive code by using functions, loops, and abstractions

**Tips:**
- **Stata - Loops:**
```stata
* Instead of repeating code:
foreach var of varlist age income education {
    summarize `var'
    replace `var' = . if `var' < 0
}

* For multiple regressions:
foreach outcome in earnings employment hours {
    regress `outcome' treatment controls
    eststo `outcome'
}
esttab * using "$output/tables/main_results.tex", replace
```

- **R - Functions:**
```r
# Create reusable functions
clean_variable <- function(x, min_val = 0) {
  x[x < min_val] <- NA
  return(x)
}

df <- df %>%
  mutate(across(c(age, income, education), clean_variable))

# Or use purrr for iteration
models <- outcomes %>%
  map(~ lm(paste(.x, "~ treatment + controls"), data = df))
```

- **Python - Functions and List Comprehensions:**
```python
def clean_variable(series, min_val=0):
    """Replace values below min_val with NaN."""
    return series.where(series >= min_val)

# Apply to multiple columns
for col in ['age', 'income', 'education']:
    df[col] = clean_variable(df[col])

# Or use list comprehension
outcomes = ['earnings', 'employment', 'hours']
models = {var: sm.OLS(df[var], df[controls]).fit() 
          for var in outcomes}
```

- Store repeated values as constants/globals
- Break complex operations into smaller, named functions
- Use descriptive function and loop variable names
- Consider creating a separate `utils.do` / `utils.R` / `utils.py` for shared functions

---

## Final Checks

- [ ] Fresh start test: Can you reproduce results starting from a clean environment?
  - **Stata:** Run `clear all`, close and reopen Stata, run master script
  - **R:** Run `rm(list = ls())` or restart R session
  - **Python:** Restart kernel or run in fresh virtual environment
  
- [ ] Test on different machine/OS if possible
  
- [ ] Verify all output files are generated as expected
  
- [ ] Check that no manual steps are required (or clearly documented if unavoidable)
  
- [ ] Run time is reasonable (<24 hours ideally) or subsampling option provided

---

**Additional Resources:**
- [Project TIER Protocol](https://www.projecttier.org/)
- [AEA Data Editor Guidance](https://aeadataeditor.github.io/)
- [rOpenSci Reproducibility Guide](https://ropensci.github.io/reproducibility-guide/)
- [The Turing Way - Guide for Reproducible Research](https://the-turing-way.netlify.app/)