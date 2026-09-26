# Agent Index 上位10件の使用量集計の調査

調査日: 2026-09-26。対象は [Agent Index](https://aiworthusing.com/agent-index/) の既定表示の上位10件。順位と数値は [公開 API](https://agent-index-server.vercel.app/v1/agents) と、ページが呼ぶ `/v1/installs` と `/v1/usage` で確認した。各リポジトリは同日に `git clone --depth 1` して、README、導入文書、Dockerfile、compose ファイルを読んだ。

## 結論

- 上位10件はすべて Plow のベースイメージ `public.ecr.aws/e1h7x4a2/plow-cloud-agents:base-*` から作られている。使用量の報告器は、このベースイメージの s6 サービス `agent-index` に入っている。
- 報告を始める条件は、コンテナの環境に `AGENT_ID` があること。9件はリポジトリの Dockerfile か compose に書いてある。Life Assistant だけはリポジトリになく、コンテナの環境から受け取る（`image/s6-overlay/s6-rc.d/agent-index/run`）。導入者に「報告を有効にする」操作を求める README はない。
- 報告器は初回に `PLOW_AGENT_TOKEN` を report-only の `aik_` キーに交換する。以後は5分ごとに、日別・モデル別のトークン数とランダムなインストール ID を送る。Plow の回線を持たない導入は登録できず、数えられない。
- README に報告の説明がなくても人数は増える。3位の Zoen は README に報告の説明がない。
- 上位10件のうち9件は Hermes ハッカソンの参加作品で、Life Assistant は Plow 自身のエージェントである。Hermes の66件の合計は270人、OpenClaw の17件の合計は20人。人数の差の大部分は、ハッカソンの規模と参加者の範囲の差である。
- 導入が **Text this agent**（1クリックでのデプロイ）経由か、手元の `docker compose` 経由かは、公開 API からは区別できない。

## Index の数え方

ページ実装（`https://aiworthusing.com/agent-index/` のインライン JS）で確認した。

- `deployable_at` があるエージェントでは、詳細ページの **Text this agent** が SMS リンクになる。宛先は `+1 628 246-3032`、本文は `Set this up for me: aiworthusing.com/agent-index/<agent_id>`。Plow がこの依頼を受けて、送信者の回線でエージェントを起動する。`install_url` のリンクは、その下に「Deploy locally」として出るだけ（`renderInstall`）。
- ページのコメントは、1クリック対応のエージェントでは導入の試行を「Plow が受けた SMS の依頼」として Plow ユーザーごとに1回数える、と説明している（`wireDeploy`）。ただし公開 API の数字では、10件すべてで `/v1/installs` の `attempted` が `/v1/usage` の報告者数と一致する。手元の compose で入れた人も同じ Plow の資格情報で報告するので（報告者の `provider` はすべて `plow`）、この数字から SMS 経由の導入だけを取り出すことはできない。
- 一覧の `users` は `/v1/installs` の `succeeded` と一致する。
- 既定の並び順はサーバーが返した順。そこから、動画、画像1枚以上、導入経路の3つがそろっていないものを下に回すだけ（`boardOrder`、`ready`）。利用者数の単純な降順ではない（7位は5人、8位は6人）。

| エージェント | ハッカソン | 1クリック開始日 | attempted（= 報告者数） | succeeded（= users） |
| --- | --- | --- | --- | --- |
| Prucê | hermes | 2026-09-17 | 63 | 57 |
| Founder Agent | hermes | 2026-09-17 | 70 | 52 |
| Zoen | hermes | 2026-09-17 | 43 | 43 |
| RadaR | hermes | 2026-09-17 | 30 | 30 |
| Life Assistant | なし | 2026-09-10 | 19 | 17 |
| Saved | hermes | 2026-09-18 | 13 | 12 |
| The Founder Times | hermes | 2026-09-18 | 5 | 5 |
| Fandom | hermes | 2026-09-17 | 6 | 6 |
| Clip Warden | hermes | 2026-09-17 | 2 | 2 |
| Repro Relay | hermes | 2026-09-19 | 2 | 2 |
| bluepencil | openclaw | 2026-09-25 | 2 | 2 |

OpenClaw ハッカソンの17件の中では、bluepencil は4番目に多い（dailyrecap 5、sitemaxxing 3、qyvr-openclaw 3、bluepencil 2）。bluepencil の報告者2人のうち1人は所有者本人である。

## 上位10件

| 順位 | エージェント（users） | `AGENT_ID` の場所 | 導入手順 | 報告の説明 |
| --- | --- | --- | --- | --- |
| 1 | [Prucê](https://github.com/lopesvini/pruce-hermes-agent)（57） | Dockerfile `ENV AGENT_ID=pruce`、compose `${AGENT_ID-pruce}` | `plow-agents login` / `lines` / `mint`、`docker compose up -d` | あり。Privacy 節。ベースイメージの報告器が5分ごとに送る。`AGENT_ID` を空にすると登録も報告も止まる |
| 2 | [Founder Agent](https://github.com/Tiagohbello/plow-hackathon)（52） | compose `${AGENT_ID:-founder-agent}`、`.env.example` | `docs/INSTALL.md`: `plow-agents` で `mint`、`docker compose up --build -d` | あり。INSTALL の「Verify Agent Index reporting」節。`--self-check` と `--dry-run` で確認する |
| 3 | [Zoen](https://github.com/EnzoTironi/Plow)（43） | Dockerfile `ENV AGENT_ID=zoen`、compose | README の先頭が Text this agent の SMS リンク。上級者向けに `install.sh`（同じ `:v1` イメージ）と `--local` | なし。compose のコメントに、`AGENT_ID` がないと報告が0になるとだけある |
| 4 | [RadaR](https://github.com/thematheussousa-bitnoob/radar)（30） | Dockerfile `ENV AGENT_ID=radar` | Plow CLI をコンテナで実行して `login` / `mint`、`docker compose up --build -d` | あり。What it reports 節。切る手段はないと明記 |
| 5 | [Life Assistant](https://github.com/plow-pbc/life-assistant-hermes-agent)（17） | リポジトリになし。環境から受け取る | `plow-agents` で `mint`、`docker compose up --build -d` | あり。Usage reporting 節。「There is no switch」。`AGENT_ID` がなければ待機する |
| 6 | [Saved](https://github.com/AElise08/saved-hermes-agent)（12） | Dockerfile `ENV AGENT_ID=saved`、compose | `plow-agents deploy --local`。自分の GHCR イメージを `plow-agents deploy` する手順もある | あり。Usage reporting 節。`AGENT_ID` の既定は `saved` |
| 7 | [The Founder Times](https://github.com/jeanjacintho/the-plow-times-hermes-agent)（5） | compose `AGENT_ID: theplowtimes` | `plow-agents mint`、`docker compose up --build -d` | なし |
| 8 | [Fandom](https://github.com/emanuellcoelho/fandom-hermes-agent)（6） | Dockerfile `ENV AGENT_ID=fandom`、compose | `plow-agents mint`、`docker compose up --build -d` | あり。Privacy 節。トークン数だけを送る |
| 9 | [Clip Warden](https://github.com/bruno-dotcom12/clip-warden)（2） | Dockerfile `ENV AGENT_ID=clip-warden`、compose | `./install.sh`。公開 GHCR イメージを取得する | あり。README の Where it connects、INSTALL にも記載 |
| 10 | [Repro Relay](https://github.com/lusknchars/repro-relay)（2） | `cloud/Dockerfile` `ENV AGENT_ID=repro-relay`、`agent/compose.yml` | `./relay agent` が login から最初の返信の確認まで進める | あり。`agent/README.md` の Usage reporting 節。確認コマンドもある |

Dockerfile の FROM は4種類の digest に分かれるが、どれも同じ `plow-cloud-agents:base-*` 系列である。Life Assistant と Fandom は、報告クライアントを commit と sha256 で固定して、自分でも取得している。

## bluepencil の状況

- Index の登録内容: `deployable_at: 2026-09-25`、`install_url: https://github.com/yasuhito/bluepencil#install`、`users: 2`、installs は 2 件中 2 件成功。1クリックが使えるようになったのは、上位のエージェントより8日ほど遅い。
- 1クリックの Text this agent はすでに使える。これで入れた人は、`cloud/Dockerfile` の `AGENT_ID=bluepencil` とベースイメージの報告器によって、自動で数えられる。
- README の `#install` は自前の OpenClaw Gateway 向けの手順で、報告器がない。`tools/index-bridge` は登録に `PLOW_AGENT_TOKEN` が要る（`agent_index_client.py` の `index_assertion`）。つまり所有者のマシン用の仕組みで、一般の導入者は数えられない。
- GitHub のトラフィック（直近14日）: クローン 184 回（ユニーク 92）、ただし 9/22 と 9/23 に集中している。同じ期間の CI 実行は 8 回。閲覧はユニーク 5、aiworthusing.com からの流入はユニーク 2。数えられていない利用者が多いことを示す証拠は見つからなかった。

## 対応

- README の Install の先頭に Text this agent の導線を置き、自前の Gateway の手順を後ろに回す。自前の Gateway では Index に数えられないことを明記する。
- 報告内容の説明を足す。上位8件と同じ扱いにする。
- 自前の Gateway の利用者を数えるには、Plow の回線とトークンが要る。README の変更では解決しない。
