Written at 📅 2024-10-06 23:05:10
# Summary of My Understanding of the Attention Mechanism in NLP

1. **Embedding Vectors**:
   - Embedding vectors are representations of words in a high-dimensional vector space, capturing their semantic meaning. These vectors are learned during training using an embedding layer or pre-trained embedding models such as **Word2Vec**, **GloVe**, or **FastText**.
   - Once learned, these vectors become **fixed** and do not change during inference (testing). They can be fine-tuned during the training phase of an attention-based model if the embedding layer is trainable.
   - The attention mechanism **does not alter** the embedding vector itself. Instead, it applies learned weights to the embedding vectors to compute the final output.

2. **Attention Mechanism**:
   - The attention mechanism computes **weights** (importance scores) between the **Query** (the current word) and **Key** (other words in the sequence).
   - These weights determine how much focus the model should give to each word in the context when processing the current word.
   - The weights are applied to the **embedding vectors (Values)** to compute the attention output.

3. **Training Process**:
   - During training, the model learns the best set of weights for different Query-Key pairs. While the attention mechanism updates these weights, the embedding vectors may also be fine-tuned during the training process if the embedding layer is not pre-trained.
   - The attention mechanism primarily updates the weights between Query-Key pairs but does not modify the embedding vectors directly.

4. **Inference**:
   - During inference, the learned embedding vectors remain constant, and the pre-trained attention weights are applied to generate the final output.

## Self-Attention in NLP (Numerical Example)

Let's break down how **Self-Attention** is computed in a concrete numerical example using the sentence: **"The cat sat on the mat"**. We'll calculate the **Query (Q)**, **Key (K)**, and **Value (V)** for each word and show how these vectors are used to compute the attention mechanism.

### Sentence: "The cat sat on the mat"

For this example, assume each word is transformed into a **3-dimensional embedding vector**. These embeddings capture the semantic meaning of each word.

### Step 1: **Word Embedding Vectors**
Let's assume the following **embedding vectors** for each word:
- "The" → $[0.1, 0.2, 0.3]$
- "cat" → $[0.5, 0.1, 0.2]$
- "sat" → $[0.4, 0.6, 0.7]$
- "on" → $[0.3, 0.1, 0.5]$
- "the" → $[0.1, 0.2, 0.3]$
- "mat" → $[0.6, 0.5, 0.1]$

### Step 2: **Compute Q, K, V**
For each word, we compute the **Query (Q)**, **Key (K)**, and **Value (V)** vectors by applying linear transformations (matrix multiplications) to the embedding vectors. These linear transformations are parameterized by weight matrices $W_Q$, $W_K$, and $W_V$, which are learned during training. 

🚣 **However, the Value (V) itself is not directly learned; the learned attention weights are applied to V to compute the final output.**

For simplicity, let’s assume that for the word "The", the vectors are transformed as follows:
- "The" → $Q = [0.2, 0.3, 0.1]$, $K = [0.4, 0.2, 0.3]$, $V = [0.1, 0.2, 0.3]$

The same process is applied to all other words in the sentence, and for "cat", we have:
- "cat" → $Q = [0.3, 0.1, 0.4]$, $K = [0.5, 0.1, 0.6]$, $V = [0.4, 0.1, 0.2]$

### Step 3: **Compute Attention Scores (Q · K^T)**
For each word, we compute the **dot product** between the Query vector of the current word and the Key vectors of all words in the sentence (including itself). This gives us the attention scores, which represent how much focus should be given to each word when processing the current word.

For example, to compute the attention score between "The" (Q) and "cat" (K):
$$
Q_{\mathrm{The}} \cdot K_{\mathrm{cat}} = 0.2 \times 0.5 + 0.3 \times 0.1 + 0.1 \times 0.6 = 0.10 + 0.03 + 0.06 = 0.19
$$

This process is repeated for every word in the sentence, and the resulting scores are:
- Attention score between "The" and "cat": 0.19
- Attention score between "The" and "sat": $Q_{\mathrm{The}} \cdot K_{\mathrm{sat}}$, and so on.

### Step 4: **Apply Softmax to the Scores**
Once the attention scores are computed, they are normalized using the **softmax function** to ensure the scores sum up to 1. This allows the model to focus on certain words more than others.

For example, the attention scores for "The" could be:
- Softmax([0.19, 0.22, 0.18, 0.21, 0.20]) → [0.18, 0.21, 0.17, 0.20, 0.19]

### Step 5: **Weighted Sum of Values**
Finally, the softmaxed attention scores are used to compute a **weighted sum of the Value vectors**. This gives the final attention output for the word.

For "The", the weighted sum of the Value vectors would be:
$$
\text{Attention Output}_{\mathrm{The}} = 0.18 \times V_{\mathrm{The}} + 0.21 \times V_{\mathrm{cat}} + \dots
$$
Where $V_{\mathrm{The}} = [0.1, 0.2, 0.3]$, $V_{\mathrm{cat}} = [0.4, 0.1, 0.2]$, and so on.

---

## Additional Explanation about Q, K, V and Linear Transformation

1. **Why are Q, K, and V represented as 2-dimensional vectors in the example?**
   - In the example, Q, K, and V were simplified into 2-dimensional vectors for easier explanation. In reality, these vectors are often higher-dimensional, and the Self-Attention mechanism calculates the relationships between all the words in the sentence, not just two.

2. **Why does the embedding vector undergo a linear transformation before becoming Q, K, or V?**
   - The embedding vector represents the semantic meaning of a word, but in the Self-Attention mechanism, the model needs to calculate how this word relates to other words in the context. Therefore, a linear transformation is applied to the embedding vector to create separate Q, K, and V vectors, each serving a specific role.
   - 🚣 **Q, K, and V are the result of a linear transformation applied to the embedding vectors.**
   - 🚣 **While Value (V) is not learned directly, embedding vectors themselves can be fine-tuned during training, which indirectly affects the values used in the attention mechanism.**

The linear transformation allows the model to learn how to best represent the relationships between words during training.
