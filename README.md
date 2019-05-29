# fmri_utils
Various tools to perform analyses of fMRI data.

**Requirements**
- SPM
- rsatoolbox




## Preprocessing
 fMRI preprocessing routines. allows you to avoid the SPM GUI entirely.
 Parameters are defined in `fmri_preproc_setParams()`.  
 To run all steps defined in the params file in one go, call `fmri_preproc_runner()`  

**Table of Contents:**
```bash
.
├── fmri_preproc_coregistration.m
├── fmri_preproc_dicomImport.m
├── fmri_preproc_normalisation.m
├── fmri_preproc_realignUnwarp.m
├── fmri_preproc_runner.m
├── fmri_preproc_segmentation.m
├── fmri_preproc_setParams.m
├── fmri_preproc_slicetimeCorr.m
├── fmri_preproc_smooth.m
├── fmri_preproc_structureData.sh
└── fmri_spm_preproc_prefixes.md

```
## GLM
 Generalised Linear Model estimation, interfaces SPM and operates mostly on nifti (or whichever format you prefer) images.  

 **Features:**
 - define conditions, number of nuisance regressors and runs, automatically generate design for whole session.
 - estimate the model
 - perform 1st level contrasts (of as many contrast as you wish, in one go)
 - perform 2nd level inference, generates group-level T-Map.
 - do above in leave-one-subject-out manner, for functional ROIs  
 

 Again, all parameters adjusted set in one file, `fmri_glm_setParams()`


**Table of Contents**
```bash
.
├── fmri_glm_contrast_1stLevel.m
├── fmri_glm_contrast_2ndLevel_LOSO.m
├── fmri_glm_contrast_2ndLevel.m
├── fmri_glm_contrast_generate.m
├── fmri_glm_designMatrix.m
├── fmri_glm_estimate.m
└── fmri_glm_setParams.m

```


## RSA
Representational Similarity Analysis. Mostly custom code which operates directly on matlab matrices.

```bash
.
├── compute
│   ├── fmri_rsa_compute_performRSA_ROI.m
│   ├── fmri_rsa_compute_performRSA_searchlight.m
│   ├── fmri_rsa_compute_rdmSet_avg.m
│   ├── fmri_rsa_compute_rdmSet_cval.m
│   └── fmri_rsa_compute_setParams.m
├── convert
│   ├── fmri_rsa_convert_mni2rdm.m
│   └── fmri_rsa_convert_struct2mat.m
├── disp
│   ├── fmri_rsa_disp_rdmReplicabilityBehav.m
│   ├── fmri_rsa_disp_rdmReplicability.m
│   ├── fmri_rsa_disp_showCorrs_MultipleROIs.m
│   ├── fmri_rsa_disp_showCorrs_ROI.m
│   ├── fmri_rsa_disp_showMDS.m
│   ├── fmri_rsa_disp_showRDM.m
│   ├── fmri_rsa_disp_showRDMs.m
│   ├── fmri_rsa_disp_showRewardMDS.m
│   └── fmri_rsa_disp_showTSNE.m
├── helper
│   ├── fmri_rsa_helper_betasInRewSpace.m
│   ├── fmri_rsa_helper_genImageStruct.m
│   ├── fmri_rsa_helper_getBetas.m
│   ├── fmri_rsa_helper_getResiduals.m
│   ├── fmri_rsa_helper_rdmReplicabilityBehav.m
│   ├── fmri_rsa_helper_rdmReplicability.m
│   └── fmri_rsa_helper_whiten.m
├── mds
│   └── fmri_rsa_mds_rdmToND.m
├── modelcorrs
│   ├── fmri_rsa_corrs_corrBrainRDMs_ROI.m
│   ├── fmri_rsa_corrs_corrBrainRDMs_Searchlight.m
│   ├── fmri_rsa_corrs_genCorrImagesAndMaskedCorrs.m
│   ├── fmri_rsa_corrs_genModelRDMs_cval.m
│   ├── fmri_rsa_corrs_genModelRDMs.m
│   ├── fmri_rsa_corrs_genSigImages_Searchlight.m
│   ├── fmri_rsa_corrs_noiseCeiling.m
│   ├── fmri_rsa_corrs_setParams.m
│   ├── fmri_rsa_corrs_sigtest_ROI.m
│   └── fmri_rsa_corrs_sigtest_Searchlight.m
├── tsne
│   └── fmri_rsa_tsne_rdmTo2D.m
└── wrappers
    ├── wrapper_rsa_computeRDMs_roi.m
    ├── wrapper_rsa_corr_roi.m
    ├── wrapper_rsa_makeCorrFigure_MultipleROIs.m
    ├── wrapper_rsa_makeCorrFigure_ROI.m
    ├── wrapper_rsa_makeMDSfigure.m
    ├── wrapper_rsa_makeRDMfigure.m
    ├── wrapper_rsa_makeSingleSubsRDMFigures.m
    ├── wrapper_rsa_noiseCeiling_roi.m
    └── wrapper_rsa_sigtest_roi.m

```

## IO  
helper functions to convert image files to MATLAB matrices and vice versa

```bash
.
├── fmri_io_mat2nifti.m
├── fmri_io_nifti2mat.m
├── fmri_io_reslice.m
└── fmri_io_setParams.m

```

## Mask
generate and apply masks

```bash
.
├── fmri_mask_genGroupMask.m
├── fmri_mask_genSphericalMask.m
├── fmri_mask_mask2ind.m
├── fmri_mask_MDparcellation.m
└── fmri_mask_mni2roi.m


```


## Helper
various auxiliary functions

```bash
.
├── fmri_helper_changeSPMpaths.m
├── fmri_helper_dispContrastVectors.m
├── fmri_helper_genConImgNames.m
├── fmri_helper_genContrastVector.m
|── fmri_helper_genVolume.m
├── fmri_helper_genWeightedContrastVector.m
├── fmri_helper_set_fileName.m
└── plot_progbar_cli.m

```
