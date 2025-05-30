---
title: Hugging Face Transformers.js
date: 2024-12-02
authors: pelikhan
tags:
  - LLM
  - SLM
  - transformers
  - Hugging Face
  - JavaScript
canonical_url: https://microsoft.github.io/genaiscript/blog/hugging-face-transformers
description: Learn how to run LLMs locally using Hugging Face Transformers.js in
  GenAIScript, enabling you to leverage powerful language models in your
  JavaScript projects.
cover:
  alt: An 8-bit style image displays various technology icons symbolizing
    JavaScript, transformers, and AI. These icons are integrated into an
    arrangement of abstract geometric shapes that represent a browser and server
    environment. The image is simplified using a 5-color palette, maintaining a
    consistent and coherent aesthetic. No people or text are present.
  image: ./hugging-face-transformers.png

---

<p style="text-align:center"><span style="font-size: 12rem;">🤗</span></p>

[Hugging Face Transformers.js](https://huggingface.co/docs/transformers.js/index) 
is a JavaScript library that provides a simple way to run LLMs in the browser or node.js (or Bun, Deno, ...).

With the latest GenAIScript, you can use [Text Generation Models](https://huggingface.co/tasks/text-generation#completion-generation-models) directly in the script configuration
using the [transformers](/genaiscript/getting-started/configuration#transformers) model provider.

```js 'model: "transformers:HuggingFaceTB/SmolLM2-1.7B-Instruct:q4f16"'
script({
  model: "transformers:HuggingFaceTB/SmolLM2-1.7B-Instruct:q4f16"
})
```

GenAIScript will download and cache the model for you, and you can start using it right away
**fully locally**.

There are [plenty of models](https://huggingface.co/models?pipeline_tag=text-generation&library=transformers.js) to choose from and you can also follow the Hugging Face documentation to fine tune your own.
