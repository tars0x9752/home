#!/usr/bin/env bash

# Nixで管理していないものとパスが被ってたらsuffixに.bckをつけたコピーを自動生成する.
home-manager switch --flake '.#tars' -b bck 
