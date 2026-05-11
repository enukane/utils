# ifctl - macOS ネットワークインタフェース管理ユーティリティ

## 概要

USB Ethernet および VLAN インタフェースの一覧表示・アドレス設定・VLAN管理を行う bash スクリプト。

## コマンド体系

```
ifctl                                        # インタフェース一覧
ifctl list                                   # 同上
ifctl add <ifname> <addr/mask> [gw <gw>]     # アドレス設定（既存を上書き）
ifctl del <ifname>                           # アドレス・GW削除
ifctl add-vlan <ifname> <vlan_id>            # VLAN作成
ifctl del-vlan <vlan_id>                     # 該当VLAN IDを全て削除
```

## 前提条件

- macOS (Darwin) 専用
- root権限で実行（非rootはエラー終了）
- 言語: bash

## インタフェース検出ロジック

- `networksetup -listallhardwareports` で全ハードウェアポートを取得
- `ifconfig` で現在アクティブなインタフェースを取得
- 両方に存在するもの = 表示対象
- **除外**: Hardware Port名に `Thunderbolt`, `Wi-Fi`, `Bluetooth`, `FireWire` を含むもの、`lo0`
- **VLAN**: `ifconfig` で `vlan` プレフィックスを持つインタフェースも表示対象に追加
- **type分類**: VLANインタフェース→`vlan`、それ以外→`eth`、判別不能→`other`

## list 出力フォーマット

```
en23:
  name: AX88179A
  type: eth
  macaddr: aa:bb:cc:dd:ee:ff
  addr:
    - 192.168.20.100/24
    - fe80::1%en23/64
  gw: 192.168.20.1
  vlan:
    - 1600
  tag:
vlan0:
  name: VLAN1600
  type: vlan
  macaddr: aa:bb:cc:dd:ee:ff
  addr:
    - 10.16.0.100/24
  gw:
  vlan:
  tag: 1600
```

### フィールド説明

| フィールド | 説明 |
|-----------|------|
| name | `networksetup -listallhardwareports` で得られるハードウェアポート名 |
| type | `eth`, `vlan`, `other` のいずれか |
| macaddr | MACアドレス |
| addr | IPv4/IPv6アドレスとプレフィックス長の一覧 |
| gw | そのインタフェース経由のデフォルトゲートウェイ（なければ空） |
| vlan | そのインタフェースを親とするVLANのタグ一覧 |
| tag | 自身がVLANインタフェースの場合のVLANタグ |

## 各操作の詳細

### add

1. `ifconfig <if>` で既存のinetアドレスを全て取得し `ifconfig <if> inet delete <addr>` で削除
2. そのインタフェース経由のデフォルトルートを `route delete default -ifscoped <if>` で削除
3. `ifconfig <if> inet <addr/mask>` で設定
4. `gw` 指定があれば `route add default <gw>` を実行

### del

1. `ifconfig <if>` から既存inetアドレスを全削除
2. そのインタフェース経由のデフォルトルートを削除

### add-vlan

1. `ifconfig vlan create` で新しいvlanインタフェースを生成（デバイス名が返る）
2. `ifconfig <vlanif> vlan <id> vlandev <parent>` でタグと親を設定

### del-vlan

1. `ifconfig -a` から指定VLAN IDを持つ全vlanインタフェースを特定
2. それぞれ `ifconfig <vlanif> destroy` で削除

## ゲートウェイ検出

`netstat -rn` の出力から、各インタフェース経由の `default` エントリのgatewayを取得。
