# earthquakeSim
Ground acceleration records are simulated using the non-stationnary Kanai–Tajimi model


Non-stationary ground acceleration records are simulated based on the example proposed in the paper of Guo et al. [3] that I have found well explained. However, the method itself is older, see e.g. [1, 2]. The present submission contains, in addition, a Matlab function to fit the non-stationary Kanai–Tajimi model to ground acceleration records.


The optimization toolbox is required for the fitting procedure (lsqcurvefit). However, other functions may alternatively be used. The signal processing toolbox is used here through the function filtfilt.Any comment, question or suggestions to improve the code is warmly welcomed.

References

[1] Lin, Y. K., & Yong, Y. (1987). Evolutionary Kanai-Tajimi earthquake models. Journal of engineering mechanics, 113(8), 1119-1137.

[2] Rofooei, F. R., Mobarake, A., & Ahmadi, G. (2001). Generation of artificial earthquake records with a nonstationary Kanai–Tajimi model. Engineering Structures, 23(7), 827-837.

[3] Guo, Y., & Kareem, A. (2016). System identification through nonstationary data using Time-Frequency Blind Source Separation. Journal of Sound and Vibration, 371, 110-131.
