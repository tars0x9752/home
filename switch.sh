#!/usr/bin/env bash

# 被ってる設定ファイルはsuffixに.bckをつけたコピーを自動生成する.
home-manager switch --flake '.#tars' -b bck 
