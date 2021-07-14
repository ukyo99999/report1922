# 簡訊實聯制 - 1922場所回報小工具
<img src='https://i.imgur.com/VFNPdvO.png'>

#### 為了解決Android的相機對於條碼掃描辨識緩慢，甚至無法辨識的情形發生，造成Android使用者在簡訊實聯制回報的困擾，開發專屬實聯制條碼掃描器。
#### 本專案使用Flutter開發，可以同時在Android與iOS執行正常

### 功能
- 實聯制條碼掃描器：掃描實聯制條碼進行場所地點回報
- 收藏常用地點代碼：常用地點直接傳送免再次掃碼
- 防止詐騙條碼：只有合法的實聯制條碼才能進行後續操作，避免誤掃詐騙條碼
- 繁中/簡中/英文語系

### 畫面
<img src='https://i.imgur.com/gCjCoGE.png?1'><img src='https://i.imgur.com/KbsWm0X.png?1'><img src='https://i.imgur.com/K4RYewi.png?1'><img src='https://i.imgur.com/hnoVqBg.png?1'><img src='https://i.imgur.com/jDOmOjs.png?1'>

### 使用說明
- 掃描實聯制條碼：按下底部 [掃條碼回報1922] 按鈕
- 收藏常用地點代碼：按下右下角的⊕新增常用地點代碼
- 常用地點代碼手勢操作：左滑刪除、右滑編輯內容、長按拖曳排序、點擊回報場所代碼

### 隱私聲明
此App沒有蒐集使用者的任何資料，也沒有網路連線的能力  
場所代碼資料只有存在App的SQLite裡，使用者刪除資料或是移除App就都消失了

## License

    Copyright 2021 Ukyo

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.