# earthquakeSim
Ground acceleration records are simulated using the non-stationnary Kanai–Tajimi model

[![View Earthquake simulation on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://se.mathworks.com/matlabcentral/fileexchange/56701-earthquake-simulation)
[![DOI](https://zenodo.org/badge/249377599.svg)](https://zenodo.org/badge/latestdoi/249377599)


[![Donation](https://camo.githubusercontent.com/a37ab2f2f19af23730565736fb8621eea275aad02f649c8f96959f78388edf45/68747470733a2f2f77617265686f7573652d63616d6f2e636d68312e707366686f737465642e6f72672f316339333962613132323739393662383762623033636630323963313438323165616239616439312f3638373437343730373333613266326636393664363732653733363836393635366336343733326536393666326636323631363436373635326634343666366536313734363532643432373537393235333233303664363532353332333036313235333233303633366636363636363536353264373936353663366336663737363737323635363536653265373337363637)](https://www.buymeacoffee.com/echeynet)


Ground acceleration records are simulated using the non-stationary Kanai–Tajimi model

Non-stationary ground acceleration records are simulated based on the example proposed in the paper of Guo et al. [3] that I have found well explained. However, the method itself is older, see e.g. [1, 2]. The present submission contains, in addition, a Matlab function to fit the non-stationary Kanai–Tajimi model to ground acceleration records.

The optimization toolbox is required for the fitting procedure (lsqcurvefit). However, other functions may alternatively be used. The signal processing toolbox is used here through the function filtfilt. Any comment, question or suggestions to improve the code is warmly welcomed.

References

[1] Lin, Y. K., & Yong, Y. (1987). Evolutionary Kanai-Tajimi earthquake models. Journal of engineering mechanics, 113(8), 1119-1137.

[2] Rofooei, F. R., Mobarake, A., & Ahmadi, G. (2001). Generation of artificial earthquake records with a nonstationary Kanai–Tajimi model. Engineering Structures, 23(7), 827-837.

[3] Guo, Y., & Kareem, A. (2016). System identification through nonstationary data using Time-Frequency Blind Source Separation. Journal of Sound and Vibration, 371, 110-131.
