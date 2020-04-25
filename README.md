# ESA-UbiSite

**ESA-UbiSite**: accurate prediction of human ubiquitination sites by identifying a set of effective negatives. Ubiquitination, the conserved proteasome system, is a PTM which relates to numerous biological processes, such as protein degradation, endocytosis, and cell cycle. Numerous ubiquitination sites remain undiscovered because of the limitations of mass spectrometry-based methods. In fact, some sites that undergo ubiquitination have not been identified. Hence, these machine learning-based prediction methods suffer from no reliable database of non-ubiquitination sites. Existing prediction methods use randomly selected non-validated sites as non-ubiquitination sites to train ubiquitination site prediction models. In this work, we propose an evolutionary screening algorithm (ESA) to select effective negatives from among non-validated sites and an ESA-based prediction method, ESA-UbiSite, to identify human ubiquitination sites. The ESA selects non-validated sites least likely to be ubiquitination sites as training negatives. Experimental results show that ESA-UbiSite with effective negatives achieved 0.92 test accuracy, better than existing prediction methods.

## Input Data

FASTA format (e.g., [example.fa](example.fa))

## Getting start

```shell
git clone https://github.com/NctuICLab/ESA-UbiSite.git
cd ESA-UbiSite
```

build AAIndex

```shell
cd src/aaindex
make
```

build LIBSVM

```shell
cd src/libsvm_320
make
```

## Run ESA-UbiSite

create a new folder for the new analysis

```shell
mkdir example_output
```

```shell
perl ESAUbiSite_main.pl example.fa example_output
```

## Result of ESA-UbiSite

[ESAUbiSite_prediction.html](example_output/ESAUbiSite_prediction.html)