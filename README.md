# tsv2bargraph

コンソール上でTSVデータを棒グラフ表示するツール
convert tsv to bargraph(console text)

```
perl tsv2bargraph.pl [OPTIONS] TSVFILE.tsv
```

- INPUT: 対象（入力）ファイル
  - TSV ファイル
  - どこかのカラムに数値が入っている
- カラム選択: "-k" で指定。
  - "-k 3" など
  - 複数選択可能。 "-k 2,3", "-k 2,4,6" など


