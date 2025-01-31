📅 Written at 2024-10-07 04:36:12

It includes additional words which Wikipedia document does not cover.

### Glossary

- **Cross-subject (X-sub)**:
  Cross-subject is a widely-used evaluation methodology in skeleton-based action recognition. In this setup, the dataset is divided into two groups based on **the identities of the subjects**.One group is used for training and the other for testing. This method aims to evaluate how well a model generalizes across different people.

  🛍️ For example, in the NTU RGB+D 120 dataset, 106 subjects are divided into two groups, where the training set contains videos from a certain group of subjects, and the evaluation set contains videos from different subjects. This method ensures that the model is not simply memorizing the actions performed by specific people but can generalize to unseen individuals.

- **Cross-setup (X-set)**:
  Cross-setup is another evaluation method, where the dataset is divided based on **environmental factors**, such as the distance or height of the cameras used to record the videos. Instead of focusing on the subjects, this setup evaluates the model’s ability to recognize actions under varying conditions, such as changes in camera position or viewpoint.

  🛍️ In the NTU RGB+D 120 dataset, videos are split based on the setup or viewpoint of the cameras, ensuring the model can generalize across different spatial conditions.
