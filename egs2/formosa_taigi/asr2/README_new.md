# ESPnet 台灣台語


\[ [English](README.md) | 中文 \]

## Introduction
目的:

提供一個自動化的台灣台語的訓練流程給大家使用，使用我們提供的程式碼可以自動下載資料集，然後使用指定的模型訓練出台灣台語模型，在最後會有驗證和測試並把結果輸出出來。

實驗:

採用的是來自我們實驗室SARC 所公開出的**TAT-MOE** 和 **Meta TAT_s2st_benchmark** ，我們將資料集整理。每個實驗模型皆訓練`max epochs 3` 並且依造進行驗證和測試 

## 環境
- date: `Tue Aug 6 15:40:32 CDT 2024`
- python version: `3.9.18 (main, Sep 11 2023, 13:41:44)  [GCC 11.2.0]`
- espnet version: `espnet 202308`
- pytorch version: `pytorch 1.13.1`
## 安裝
請參考[ESPnet_install](https://espnet.github.io/espnet/installation.html)依照指示進行安裝

如果要使用**Whisper** ，請再使用腳本前先確保先執行以下步驟，並確保虛擬環境已經激活

請先找到tools資料夾裡面的installers
```bash
cd espnet/tools/installers/
conda activate espnet
bash install_whisper.sh
```

如果要使用**LoRA**，請再使用腳本前先確保 
```bash
conda activate espnet
pip install loralib
```
Lora參考網址 [link](https://github.com/microsoft/LoRA)

**額外安裝項目** ，為了處理語料庫我們需要您在使用前安裝，如果不進行安裝則腳本執行會失敗
```python
conda activate espnet
pip install tai5-uan5_gian5-gi2_kang1-ku7  # 安裝臺灣言語工具
pip install zhon
```
台灣言語工具參考網址[link](https://i3thuan5.github.io/tai5-uan5_gian5-gi2_kang1-ku7/%E5%AE%89%E8%A3%9D.html) \
zhon參考網址[link](https://pypi.org/project/zhon/)

>[!IMPORTANT]
>
>TAT-MOE的三個資料夾會做為訓練資料，而驗證和測試資料是META TAT_ s2st_benchmark

## 語料
**TAT(Taiwanese Across Taiwan)為台語朗讀語料（reading speech）**，是以原生台文文本，收集來自台灣各地不同腔調的台語語音，並同時以6隻麥克風進行錄製。錄好的台語語音，經由兩次人工校正文本後，整理成可供語音辨認技術研究與開發使用之語音語料庫。\
**TAT-MOE (200*6 hours)** 共兩百小時並分為三個資料夾:
- Train
- Eval
- Test 

|dataset|資料量|演講者數量|
|---|---|---|
|TAT-MOE-train|80936|291|
|TAT-MOE-eval|13269|47|
|TAT-MOE-test|13087|45|

**麥克風(microphones)** 資訊: 
- 領夾式麥克風（lavalier）

**音檔（wav）** 格式:
- 取樣格式 :16kHz，16 bits PCM
- 音檔格式： *.wav

**JSON檔（metadata）格式** :
- 文件格式： *.json

```JSON
{

    "音檔長度": "6.69",

    "漢羅台文": "我欲坐八點十六分往屏東的車幫",

    "台羅": "guá beh tsē peh tiám tsa̍p-la̍k hun óng pîn-tong ê tshia-pang",

    "台羅數字調": "gua2 beh4 tse7 peh4 tiam2 tsap8-lak8 hun1 ong2 pin5-tong1 e5 tshia1-pang1",

    "白話字": "góa beh chē peh tiám cha̍p-la̍k hun óng pîn-tong ê chhia-pang",

    "字數": "14",

    "提示卡編號": "0012",

    "句編號": "1.1",

    "發音人": "IUF008",

    "性別": "女",

    "年齡": "20",

    "教育程度": "大學",

    "出生地": "屏東縣東港鎮",

    "現居地": "台中市西區",

    "腔調": "高屏普通腔",

    "錄音環境": "安靜隔音室內",

    "提示卡切換速度": "快",

    "總錄音時間(分)": "100"

}
```
更多有關語料庫的資訊請去SARC網站[台語朗讀語料](https://sites.google.com/speech.ntut.edu.tw/fsw/home/tat-corpus)

**Meta TAT_s2st_benchmark**  這是第一個台灣台語-英語並行語音資料集，可用於對台語<->英語語音到語音翻譯系統進行基準測試。
該資料集是根據TAT-Vol1-eval-lavalier （開發）和TAT-Vol1-test-lavalier （測試）創建的，其中包含台灣閩南語的錄音和文字記錄。
Meta AI創建資料集時，首先將相鄰句子連接起來形成更長的話語，透過閩英雙語將閩南文本轉錄成英語，並用真人聲音記錄英語翻譯。

**Meta TAT_s2st_benchmark** 主要分為兩個資料夾:
- Dev
- Test 

|dataset|資料量|演講者數量|
|---|---|---|
|dev-eng|722|10(5M,5F)|
|dev-hok|722|10(8M,2F)|
|test-eng|686|10(5M,5F)|
|test-hok|686|10(3M,7F)|

**麥克風(microphones)** 資訊: 
- 領夾式麥克風（lavalier）

**音檔（wav）** 格式:
- 音檔格式： *.wav

**文本格式** :
- 文件格式： *.tsv

```Tsv
id	hok_audio	hok_duration	hok_speaker	hok_accent	hok_accent_english_label	hok_gender	hok_text_tailo	hok_text_tailo_number_tone	hok_text_hanlo_tai	hok_text_pei_oe_ji	en_text	en_speaker	en_gender	en_audio	en_duration

```
**TAT_S2ST_Benchmark is released under the Attribution-NonCommercial 4.0 International (CC BY-NC 4.0) license**

更多有關語料庫的資訊請去SARC網站[TAT_s2st_benchmark](https://sites.google.com/nycu.edu.tw/sarc/tat_s2st_benchmark)

## 模型使用&腳本
- Transformer
  - [run.sh](https://github.com/yfliao/espnet/blob/master/egs2/formosa_taigi/asr2/run.sh)
- Whisper(small、medium、large)
  - [run_whisper_finetune.sh](https://github.com/yfliao/espnet/blob/master/egs2/formosa_taigi/asr1/run_whisper_finetune.sh)
- Whisper_lora(small、medium、large)
  - [run_whisper_lora_finetune.sh](https://github.com/yfliao/espnet/blob/master/egs2/formosa_taigi/asr2/run_whisper_lora_finetune.sh)

使用的模型可以更改，只需要在腳本的`asr_config`和`inference_config`替換成想要的，腳本的設置可以根據實際用途進行更改。

## 使用
確保環境架設完成後，根據自己的需求執行`bash run.sh ` 、`bash run_whisper_finetune.sh ` 、`bash run_whisper_lora_finetune.sh ` ，執行腳本後會自動下載媠聲資料集和雜訊資料集，後面會進行雜訊跟隨機分配訓練集、驗證集、測試集，接著訓練跟進行測試。

## Results
- Model link: [https://huggingface.co/espnet/jinchuat_aishell_brctc](https://huggingface.co/espnet/jinchuat_aishell_brctc)
- ASR config: [./conf/tuning/train_asr_conformer_e12_brctc_intermediate_stage1.yaml](./conf/tuning/train_asr_conformer_e12_brctc_intermediate_stage1.yaml)
- ASR config: [./conf/tuning/train_asr_conformer_e12_brctc_intermediate_stage2.yaml](./conf/tuning/train_asr_conformer_e12_brctc_intermediate_stage2.yaml)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_branchformer_asr_model_valid.acc.ave/dev|14326|205341|95.7|4.2|0.1|0.1|4.4|33.6|
|decode_asr_branchformer_asr_model_valid.acc.ave/test|7176|104765|95.4|4.4|0.2|0.1|4.7|34.7|

# Streaming Conformer + specaug + speed perturbation: feats=raw, n_fft=512, hop_length=128
## Environments
- date: `Mon Aug 23 16:31:48 CST 2021`
- python version: `3.7.9 (default, Aug 31 2020, 12:42:55)  [GCC 7.3.0]`
- espnet version: `espnet 0.9.9`
- pytorch version: `pytorch 1.5.0`
- Git hash: `b94d07028099a80c9c690341981ae7d550b5ca24`
  - Commit date: `Mon Aug 23 00:47:47 2021 +0800`

## With Transformer LM
- Model link: (wait for upload)
- ASR config: [./conf/train_asr_streaming_cpnformer.yaml](./conf/train_asr_streaming_conformer.yaml)
- LM config: [./conf/tuning/train_lm_transformer.yaml](./conf/tuning/train_lm_transformer.yaml)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_streaming_lm_lm_train_lm_transformer_zh_char_valid.loss.ave_asr_model_valid.acc.ave/dev|14326|205341|94.0|5.8|0.3|0.3|6.3|42.2|
|decode_asr_streaming_lm_lm_train_lm_transformer_zh_char_valid.loss.ave_asr_model_valid.acc.ave/test|7176|104765|92.9|6.7|0.5|0.7|7.8|46.2|


# Streaming Transformer + speed perturbation: feats=raw, n_fft=512, hop_length=128
## Environments
- date: `Tue Aug 17 01:20:32 CST 2021`
- python version: `3.7.9 (default, Aug 31 2020, 12:42:55)  [GCC 7.3.0]`
- espnet version: `espnet 0.9.9`
- pytorch version: `pytorch 1.5.0`
- Git hash: `6f5f848e0a9bfca1b73393779233bde34add3df1`
  - Commit date: `Mon Aug 16 21:50:08 2021 +0800`

## With Transformer LM
- Model link: (wait for upload)
- ASR config: [./conf/train_asr_streaming_transformer.yaml](./conf/train_asr_streaming_transformer.yaml)
- LM config: [./conf/tuning/train_lm_transformer.yaml](./conf/tuning/train_lm_transformer.yaml)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_streaming_lm_lm_train_lm_transformer_zh_char_valid.loss.ave_asr_model_valid.acc.ave/dev|14326|205341|93.6|6.2|0.1|0.5|6.8|46.8|
|decode_asr_streaming_lm_lm_train_lm_transformer_zh_char_valid.loss.ave_asr_model_valid.acc.ave/test|7176|104765|93.0|6.7|0.2|0.8|7.8|50.7|


# Whisper Large LoRA finetune

## Environments
- date: `Sun Aug  6 20:21:54 CST 2023`
- python version: `3.9.12 (main, Apr  5 2022, 06:56:58)  [GCC 7.5.0]`
- espnet version: `espnet 202304`
- pytorch version: `pytorch 1.10.1`

## Results

- ASR config: [conf/tuning/train_asr_whisper_large_lora_finetune.yaml](conf/tuning/train_asr_whisper_large_lora_finetune.yaml)
- Decode config: [conf/tuning/decode_asr_whisper_noctc_beam10.yaml](conf/tuning/decode_asr_whisper_noctc_beam10.yaml)
- Pretrained Model:
  - #Trainable Params: 7.86 M
  - Link: TBD

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_whisper_noctc_beam10_asr_model_valid.acc.ave/dev|14326|205341|97.6|2.3|0.1|0.1|2.5|22.4|
|decode_asr_whisper_noctc_beam10_asr_model_valid.acc.ave/test|7176|104765|97.3|2.6|0.1|0.1|2.7|23.9|


# Whisper Medium LoRA finetune

## Environments
- date: `Thu Aug  3 21:21:52 CST 2023`
- python version: `3.9.12 (main, Apr  5 2022, 06:56:58)  [GCC 7.5.0]`
- espnet version: `espnet 202304`
- pytorch version: `pytorch 1.10.1`

## Results

- ASR config: [conf/tuning/train_asr_whisper_medium_lora_finetune.yaml](conf/tuning/train_asr_whisper_medium_lora_finetune.yaml)
- Decode config: [conf/tuning/decode_asr_whisper_noctc_beam10.yaml](conf/tuning/decode_asr_whisper_noctc_beam10.yaml)
- Pretrained Model:
  - #Trainable Params: 4.72 M
  - Link: TBD

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_whisper_noctc_beam10_asr_model_valid.acc.ave/dev|14326|205341|96.9|3.0|0.1|0.1|3.2|27.0|
|decode_asr_whisper_noctc_beam10_asr_model_valid.acc.ave/test|7176|104765|96.6|3.3|0.1|0.1|3.5|28.8|


# Whisper Medium Full Finetune

## Environments
- date: `Thu Jul 13 12:40:44 CST 2023`
- python version: `3.9.12 (main, Apr  5 2022, 06:56:58)  [GCC 7.5.0]`
- espnet version: `espnet 202304`
- pytorch version: `pytorch 1.10.1`

## Results

- ASR config: [conf/tuning/train_asr_whisper_medium_finetune.yaml](conf/tuning/train_asr_whisper_medium_finetune.yaml)
- Decode config: [conf/tuning/decode_asr_whisper_noctc_beam10.yaml](conf/tuning/decode_asr_whisper_noctc_beam10.yaml)
- Pretrained Model:
  - #Params: 762.32 M
  - Link: [https://huggingface.co/espnet/pengcheng_aishell_asr_train_asr_whisper_medium_finetune_raw_zh_whisper_multilingual_sp](https://huggingface.co/espnet/pengcheng_aishell_asr_train_asr_whisper_medium_finetune_raw_zh_whisper_multilingual_sp) (Note that the model size is very large, ~3GB.)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_whisper_noctc_beam10_asr_model_valid.acc.ave/dev|14326|205341|97.3|2.6|0.1|0.1|2.8|24.0|
|decode_asr_whisper_noctc_beam10_asr_model_valid.acc.ave/test|7176|104765|97.1|2.8|0.1|0.1|3.0|25.5|


# E-Branchformer

## Environments
- date: `Sun Dec 18 12:21:46 CST 2022`
- python version: `3.9.15 (main, Nov 24 2022, 14:31:59)  [GCC 11.2.0]`
- espnet version: `espnet 202209`
- pytorch version: `pytorch 1.12.1`
- Git hash: `26f432bc859e5e40cac1a86042d498ba7baffbb0`
  - Commit date: `Fri Dec 9 02:16:01 2022 +0000`

## Without LM

- ASR config: [conf/tuning/train_asr_e_branchformer_e12_mlp1024_linear1024_mactrue_amp.yaml](conf/tuning/train_asr_e_branchformer_e12_mlp1024_linear1024_mactrue_amp.yaml)
- #Params: 37.88 M
- Model link: [https://huggingface.co/pyf98/aishell_e_branchformer](https://huggingface.co/pyf98/aishell_e_branchformer)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_branchformer_asr_model_valid.acc.ave/dev|14326|205341|95.9|4.0|0.1|0.1|4.2|33.1|
|decode_asr_branchformer_asr_model_valid.acc.ave/test|7176|104765|95.6|4.3|0.1|0.1|4.5|34.6|




# Branchformer: initial

## Environments
- date: `Sun May 22 13:29:06 EDT 2022`
- python version: `3.9.12 (main, Apr  5 2022, 06:56:58)  [GCC 7.5.0]`
- espnet version: `espnet 202204`
- pytorch version: `pytorch 1.11.0`
- Git hash: `58a0a12ba48634841eb6616576d39e150239b4a2`
  - Commit date: `Sun May 22 12:49:35 2022 -0400`

## Without LM
- ASR config: [conf/tuning/train_asr_branchformer_e24_amp.yaml](conf/tuning/train_asr_branchformer_e24_amp.yaml)
- #Params: 45.43 M
- Model link: [https://huggingface.co/pyf98/aishell_branchformer_e24_amp](https://huggingface.co/pyf98/aishell_branchformer_e24_amp)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|beam10_ctc0.4/dev|14326|205341|96.0|4.0|0.1|0.1|4.1|32.7|
|beam10_ctc0.4/test|7176|104765|95.7|4.2|0.1|0.1|4.4|34.1|



# Branchformer: using fast_selfattn

## Environments
- date: `Sat May 28 16:09:35 EDT 2022`
- python version: `3.9.12 (main, Apr  5 2022, 06:56:58)  [GCC 7.5.0]`
- espnet version: `espnet 202205`
- pytorch version: `pytorch 1.11.0`
- Git hash: `69141f66a5f0ff3ca370f6abe5738d33819ff9ab`
  - Commit date: `Fri May 27 22:12:20 2022 -0400`

## Without LM
- ASR config: [conf/tuning/train_asr_branchformer_fast_selfattn_e24_amp.yaml](conf/tuning/train_asr_branchformer_fast_selfattn_e24_amp.yaml)
- #Params: 42.31 M
- Model link: [https://huggingface.co/pyf98/aishell_branchformer_fast_selfattn_e24_amp](https://huggingface.co/pyf98/aishell_branchformer_fast_selfattn_e24_amp)

### CER
|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|beam10_ctc0.4/dev|14326|205341|95.8|4.1|0.1|0.1|4.3|33.3|
|beam10_ctc0.4/test|7176|104765|95.5|4.4|0.1|0.1|4.6|35.2|



# Conformer: new config

## Environments
- date: `Fri May 27 13:37:48 EDT 2022`
- python version: `3.9.12 (main, Apr  5 2022, 06:56:58)  [GCC 7.5.0]`
- espnet version: `espnet 202204`
- pytorch version: `pytorch 1.11.0`
- Git hash: `4f36236ed7c8a25c2f869e518614e1ad4a8b50d6`
  - Commit date: `Thu May 26 00:22:45 2022 -0400`

## Without LM
- ASR config: [conf/tuning/train_asr_conformer_e12_amp.yaml](conf/tuning/train_asr_conformer_e12_amp.yaml)
- #Params: 46.25 M
- Model link: [https://huggingface.co/pyf98/aishell_conformer_e12_amp](https://huggingface.co/pyf98/aishell_conformer_e12_amp)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|beam10_ctc0.4/dev|14326|205341|95.8|4.1|0.1|0.1|4.3|33.1|
|beam10_ctc0.4/test|7176|104765|95.4|4.4|0.1|0.1|4.6|34.7|



# E-Branchformer: CTC

## Environments
- date: `Sun Feb 19 13:24:02 CST 2023`
- python version: `3.9.15 (main, Nov 24 2022, 14:31:59)  [GCC 11.2.0]`
- espnet version: `espnet 202301`
- pytorch version: `pytorch 1.13.1`
- Git hash: `8fa6361886c246afbd90c6e2ef98596628bdeaa8`
  - Commit date: `Fri Feb 17 16:47:46 2023 -0600`

## Without LM, beam size 1
- ASR config: [conf/tuning/train_asr_ctc_e_branchformer_e12.yaml](conf/tuning/train_asr_ctc_e_branchformer_e12.yaml)
- Params: 26.24M
- Model link: [https://huggingface.co/pyf98/aishell_ctc_e_branchformer_e12](https://huggingface.co/pyf98/aishell_ctc_e_branchformer_e12)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_ctc_asr_model_valid.cer_ctc.ave/dev|14326|205341|94.7|5.2|0.1|0.1|5.4|40.9|
|decode_asr_ctc_asr_model_valid.cer_ctc.ave/test|7176|104765|94.2|5.7|0.1|0.1|6.0|43.0|



# Conformer: CTC

## Environments
- date: `Sun Feb 19 15:20:11 CST 2023`
- python version: `3.9.15 (main, Nov 24 2022, 14:31:59)  [GCC 11.2.0]`
- espnet version: `espnet 202301`
- pytorch version: `pytorch 1.13.1`
- Git hash: `8fa6361886c246afbd90c6e2ef98596628bdeaa8`
  - Commit date: `Fri Feb 17 16:47:46 2023 -0600`

## Without LM, beam size 1
- ASR config: [conf/tuning/train_asr_ctc_conformer_e15_linear1024.yaml](conf/tuning/train_asr_ctc_conformer_e15_linear1024.yaml)
- Params: 26.76M
- Model link: [https://huggingface.co/pyf98/aishell_ctc_conformer_e15_linear1024](https://huggingface.co/pyf98/aishell_ctc_conformer_e15_linear1024)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_ctc_asr_model_valid.cer_ctc.ave/dev|14326|205341|94.4|5.5|0.1|0.1|5.8|42.9|
|decode_asr_ctc_asr_model_valid.cer_ctc.ave/test|7176|104765|93.9|6.0|0.1|0.1|6.3|44.5|



# Conformer + specaug + speed perturbation: feats=raw, n_fft=512, hop_length=128
## Environments
- date: `Fri Oct 16 11:10:17 JST 2020`
- python version: `3.7.3 (default, Mar 27 2019, 22:11:17)  [GCC 7.3.0]`
- espnet version: `espnet 0.9.0`
- pytorch version: `pytorch 1.6.0`
- Git hash: `20b0c89369d9dd3e05780b65fdd00a9b4f4891e5`
  - Commit date: `Mon Oct 12 09:28:20 2020 -0400`

## With Transformer LM
- Model link: https://zenodo.org/record/4105763#.X40xe2j7QUE
- ASR config: [./conf/tuning/train_asr_conformer.yaml](./conf/tuning/train_asr_conformer.yaml)
- LM config: [./conf/tuning/train_lm_transformer.yaml](./conf/tuning/train_lm_transformer.yaml)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_rnn_lm_lm_train_lm_transformer_char_batch_bins2000000_valid.loss.ave_asr_model_valid.acc.ave/dev|14326|205341|95.7|4.2|0.1|0.1|4.4|33.7|
|decode_asr_rnn_lm_lm_train_lm_transformer_char_batch_bins2000000_valid.loss.ave_asr_model_valid.acc.ave/test|7176|104765|95.4|4.5|0.1|0.1|4.7|35.0|

## With RNN LM
- ASR config: [./conf/tuning/train_asr_conformer.yaml](./conf/tuning/train_asr_conformer.yaml)
- LM config: [./conf/tuning/train_lm_rnn2.yaml](./conf/tuning/train_lm_rnn2.yaml)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_rnn_lm_lm_train_lm_char_valid.loss.ave_asr_model_valid.acc.ave/dev|14326|205341|95.5|4.4|0.1|0.1|4.6|35.2|
|decode_asr_rnn_lm_lm_train_lm_char_valid.loss.ave_asr_model_valid.acc.ave/test|7176|104765|95.2|4.7|0.1|0.1|4.9|36.5|

## Without LM
- ASR config: [./conf/tuning/train_asr_conformer.yaml](./conf/tuning/train_asr_conformer.yaml)

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_rnn_asr_model_valid.acc.ave/dev|14326|205341|95.6|4.3|0.1|0.1|4.5|35.0|
|decode_asr_rnn_asr_model_valid.acc.ave/test|7176|104765|95.2|4.7|0.1|0.1|4.9|36.7|


# Transformer + speed perturbation: feats=raw with same LM with the privious setting

I compared between `n_fft=512, hop_length=128`, `n_fft=400, hop_length=160`,  and `n_fft=512, hop_length=256`
with searching the best `batch_bins` to get the suitable configuration for each hop_length.

## Environments
- date: `Fri Oct 16 11:10:17 JST 2020`
- python version: `3.7.3 (default, Mar 27 2019, 22:11:17)  [GCC 7.3.0]`
- espnet version: `espnet 0.9.0`
- pytorch version: `pytorch 1.6.0`
- Git hash: `20b0c89369d9dd3e05780b65fdd00a9b4f4891e5`
  - Commit date: `Mon Oct 12 09:28:20 2020 -0400`

## n_fft=512, hop_length=128
asr_train_asr_transformer2_raw_char_batch_typenumel_batch_bins8500000_optim_conflr0.0005_scheduler_confwarmup_steps30000_sp

- ASR config: [./conf/tuning/train_asr_transformer3.yaml](./conf/tuning/train_asr_transformer3.yaml)
- LM config: [./conf/tuning/train_lm_rnn2.yaml](./conf/tuning/train_lm_rnn2.yaml)


### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_rnn_lm_lm_train_lm_char_valid.loss.ave_asr_model_valid.acc.ave/dev|14326|205341|94.2|5.7|0.1|0.1|5.9|42.6|
|decode_asr_rnn_lm_lm_train_lm_char_valid.loss.ave_asr_model_valid.acc.ave/test|7176|104765|93.7|6.1|0.2|0.1|6.4|45.0|


## n_fft=400, hop_length=160
asr_train_asr_transformer2_raw_char_frontend_confn_fft400_frontend_confhop_length160_batch_typenumel_batch_bins6500000_optim_conflr0.0005_scheduler_confwarmup_steps30000_sp

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_rnn_lm_lm_train_lm_char_valid.loss.ave_asr_model_valid.acc.ave/dev|14326|205341|94.1|5.7|0.1|0.1|6.0|43.0|
|decode_asr_rnn_lm_lm_train_lm_char_valid.loss.ave_asr_model_valid.acc.ave/test|7176|104765|93.5|6.3|0.2|0.1|6.6|45.4|

## n_fft=512, hop_length=256
asr_train_asr_transformer2_raw_char_frontend_confn_fft512_frontend_confhop_length256_batch_typenumel_batch_bins6000000_sp

### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_rnn_lm_lm_train_lm_char_valid.loss.ave_asr_model_valid.acc.ave/dev|14326|205341|94.0|5.9|0.1|0.1|6.1|43.5|
|decode_asr_rnn_lm_lm_train_lm_char_valid.loss.ave_asr_model_valid.acc.ave/test|7176|104765|93.3|6.5|0.2|0.1|6.8|45.8|


# Transformer + speed perturbation: feats=fbank_pitch, RNN-LM
Compatible setting with espnet1 to reproduce the previou result

## Environments
- date: `Fri Oct 16 11:10:17 JST 2020`
- python version: `3.7.3 (default, Mar 27 2019, 22:11:17)  [GCC 7.3.0]`
- espnet version: `espnet 0.9.0`
- pytorch version: `pytorch 1.6.0`
- Git hash: `20b0c89369d9dd3e05780b65fdd00a9b4f4891e5`
  - Commit date: `Mon Oct 12 09:28:20 2020 -0400`

- ASR config: [./conf/tuning/train_asr_transformer2.yaml](./conf/tuning/train_asr_transformer2.yaml)
- LM config: [./conf/tuning/train_lm_rnn2.yaml](./conf/tuning/train_lm_rnn2.yaml)

## asr_train_asr_transformer2_fbank_pitch_char_sp
### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_asr_rnn_lm_lm_train_lm_char_valid.loss.ave_asr_model_valid.acc.ave/dev|14326|205341|94.0|5.9|0.1|0.1|6.1|43.4|
|decode_asr_rnn_lm_lm_train_lm_char_valid.loss.ave_asr_model_valid.acc.ave/test|7176|104765|93.4|6.4|0.2|0.1|6.7|45.9|

# The first result
## Environments
- date: `Sun Feb  2 02:03:55 CST 2020`
- python version: `3.7.3 (default, Mar 27 2019, 22:11:17)  [GCC 7.3.0]`
- espnet version: `espnet 0.6.0`
- pytorch version: `pytorch 1.1.0`
- Git hash: `e0fd073a70bcded6a0e6a3587630410a994ccdb8` (+ fixing https://github.com/espnet/espnet/pull/1533)
  - Commit date: `Sat Jan 11 06:09:24 2020 +0900`

## asr_train_asr_rnn_new_fbank_pitch_char
### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_devdecode_asr_rnn_lm_valid.loss.best_asr_model_valid.acc.best|14326|205341|92.6|7.2|0.2|0.1|7.5|49.6|
|decode_testdecode_asr_rnn_lm_valid.loss.best_asr_model_valid.acc.best|7176|104765|91.6|8.2|0.3|0.2|8.6|53.4|

## asr_train_asr_transformer_lr0.002_fbank_pitch_char
### CER

|dataset|Snt|Wrd|Corr|Sub|Del|Ins|Err|S.Err|
|---|---|---|---|---|---|---|---|---|
|decode_dev_decode_asr_rnn_lm_train_lm_char_valid.loss.best_asr_model_valid.acc.best|14326|205341|93.3|6.5|0.2|0.1|6.8|45.6|
|decode_test_decode_asr_rnn_lm_train_lm_char_valid.loss.best_asr_model_valid.acc.best|7176|104765|92.7|7.1|0.3|0.1|7.4|47.6|
