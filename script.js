document.addEventListener('DOMContentLoaded', () => {
    // DOM要素のキャッシュ
    const inputUrl = document.getElementById('inputUrl');
    const outputUrl = document.getElementById('outputUrl');
    const inputCount = document.getElementById('inputCount');
    const outputCount = document.getElementById('outputCount');
    const clearBtn = document.getElementById('clearBtn');
    const copyBtn = document.getElementById('copyBtn');
    const toast = document.getElementById('toast');

    // コアロジック: 「あ」を消去して画面を更新
    const processUrls = () => {
        const rawValue = inputUrl.value;
        
        // 正規表現で日本語の「あ」をすべてグローバル置換
        const cleanedValue = rawValue.replace(/あ/g, '');

        // 出力フィールドの更新
        outputUrl.value = cleanedValue;

        // 文字数カウンターの更新
        inputCount.textContent = `${rawValue.length} 文字`;
        outputCount.textContent = `${cleanedValue.length} 文字`;

        // コピーボタンの有効/無効化制御
        copyBtn.disabled = cleanedValue.trim().length === 0;
    };

    // クリップボードへのコピー処理と通知アニメーション
    const copyToClipboard = async () => {
        if (!outputUrl.value) return;

        try {
            await navigator.clipboard.writeText(outputUrl.value);
            
            // トースト通知の表示フェードイン・アウト
            toast.classList.add('show');
            setTimeout(() => {
                toast.classList.remove('show');
            }, 2000);
        } catch (err) {
            console.error('クリップボードへのコピーに失敗しました:', err);
            alert('コピーに失敗しました。ブラウザの権限を確認してください。');
        }
    };

    // データの全クリア
    const clearAll = () => {
        inputUrl.value = '';
        processUrls();
        inputUrl.focus();
    };

    // イベントリスナーの登録
    inputUrl.addEventListener('input', processUrls);
    clearBtn.addEventListener('click', clearAll);
    copyBtn.addEventListener('click', copyToClipboard);

    // 初期化実行（リロード時のブラウザキャッシュ対策）
    processUrls();
});
