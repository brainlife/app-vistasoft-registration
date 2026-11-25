<h1 align="center">Register DWI to T1 using vistasoft</h1>

<p align="center">
  A diffusion-weighted image aligned and resampled to a T1-weighted anatomy, with rotated bvecs, using vistasoft.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/bl.app.50"><img src="https://img.shields.io/badge/Brainlife-bl.app.50-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> 📍 **This branch, `1.1`, is the brainlife.io App Register DWI to T1 using Vistasoft** ([doi:10.25663/bl.app.50](https://doi.org/10.25663/bl.app.50)).

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Registers a DWI to a T1-weighted image with vistasoft (dtiRawAlignToT1), resamples it and rotates the bvecs.**

Builds a b0 brain image with FSL select_dwi_vols and bet, aligns it to the T1 with vistasoft dtiRawAlignToT1, resamples the DWI with dtiRawResample and reorients the bvecs with dtiRawReorientBvecs. Use it to bring DWI into T1 (for example ACPC-aligned) space before tracking.

| | |
|---|---|
| 📥 **Inputs** | `neuro/dwi` · `neuro/anat/t1w` |
| 📤 **Outputs** | `neuro/dwi` |
| 🐳 **Container** | `brainlife/mcr:neurodebian1604-r2017a` |
| 🔗 **Run it** | [doi.org/10.25663/bl.app.50](https://doi.org/10.25663/bl.app.50) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | The path to the DWI datatype |
| `t1` | `neuro/anat/t1w` | yes | The path to the anat/t1w datatype |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/dwi` | Aligned DWI with corrected bvectors and bvalues |

<details>
<summary><b>⚙️ Parameters</b> (2)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `interpolation` | enum | `linear` | Interpolation for dtiRawResample: linear maps to [0 0 0 0 0 0], trilinear to [1 1 1 0 0 0] and spline to [7 7 7 0 0 0] (SPM-style interpolation codes). Options: `linear`, `trilinear`, `spline`. |
| `resolution` | string |  | Output voxel size passed to dtiRawResample as a string (e.g. '2 2 2'); leave empty to keep the DWI's voxel size. |

</details>

<!-- brainlife-app:end -->

## 🚀 Running the App

### ☁️ On brainlife.io

Open the App at [doi.org/10.25663/bl.app.50](https://doi.org/10.25663/bl.app.50), choose a `neuro/dwi` dataset and a T1-weighted image (`neuro/anat/t1w`) from your project, set the options and press **Execute**. The App writes a `neuro/dwi` dataset tagged `t1_aligned` to your project, which can be used in any App that takes a DWI. Use it to bring DWI into T1 (for example ACPC-aligned) space before tracking.

- **`interpolation`** (default `linear`): the interpolation used by `dtiRawResample`: `linear`, `trilinear` or `spline` (SPM-style codes `[0 0 0 0 0 0]`, `[1 1 1 0 0 0]` and `[7 7 7 0 0 0]`).
- **`resolution`**: the output voxel size as a string, for example `"2 2 2"`. Leave it empty to keep the DWI's voxel size.

### 🔬 How it works

1. A b0 image is built from the DWI with FSL `select_dwi_vols` and skull-stripped with `bet` (brainmask script).
2. The b0 brain image is aligned to the T1 with vistasoft `dtiRawAlignToT1`.
3. The resulting transform is used to resample the DWI with `dtiRawResample`.
4. The bvecs are rotated by the same transform with `dtiRawReorientBvecs`.

Steps 2–4 run as compiled MATLAB.

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). The App uses the `brainlife/fsl:5.0.9` and `brainlife/mcr:neurodebian1604-r2017a` containers.

1. Clone this repository and check out the registered version (`git checkout 1.1`).
2. Create `config.json` with the paths to your inputs and the options you want:

   ```json
   {
       "t1": "./input/t1/t1.nii.gz",
       "dwi": "./input/dwi/dwi.nii.gz",
       "bvals": "./input/dwi/dwi.bvals",
       "bvecs": "./input/dwi/dwi.bvecs",
       "interpolation": "linear",
       "resolution": ""
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

To run the MATLAB code without Singularity you need [vistasoft](https://github.com/vistalab/vistasoft/), [SPM 8](https://www.fil.ion.ucl.ac.uk/spm/software/spm8/), [jsonlab](https://github.com/fangq/jsonlab) and FSL.

### 🧪 Sample data

Download a T1-weighted image and a DWI from brainlife.io with the [brainlife CLI](https://github.com/brainlife/cli):

```bash
npm install -g brainlife
bl login
mkdir input
bl dataset download 5b96bbbf059cf900271924f2 && mv 5b96bbbf059cf900271924f2 input/t1
bl dataset download 5b96bbf2059cf900271924f3 && mv 5b96bbf2059cf900271924f3 input/dwi
```

## 📦 Outputs

```text
dwi.nii.gz           DWI aligned and resampled to the T1
dwi.bvals            b-values
dwi.bvecs            bvecs rotated by the registration
acpcTransform.mat    vistasoft transform from DWI to T1 space
```

## 🩺 Troubleshooting

- **`output missing`**: the b0 brain image (`nodif.nii.gz`) or the aligned `dwi.nii.gz` was not produced. Check that the bvals contain b=0 volumes and inspect the logs.
- **`Interpolation method not defined`**: `interpolation` must be `linear`, `trilinear` or `spline`.

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Register DWI to T1 using Vistasoft. brainlife.io App. [doi:10.25663/bl.app.50](https://doi.org/10.25663/bl.app.50)
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## 👥 Authors

- Brad Caron
- Franco Pestilli (project director)

**Contributors:** Soichi Hayashi

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

MIT (see the [`LICENSE`](https://github.com/brainlife/app-vistasoft-registration/blob/1.1/LICENSE) file on the `1.1` branch). FSL is distributed under its own [license](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence).
