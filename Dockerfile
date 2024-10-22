# 此工作流使用未经 GitHub 认证的操作。
# 它们由第三方提供，并受
# 单独的服务条款、隐私政策和支持
# 文档。

# GitHub 建议将操作固定到提交 SHA。
# 若要获取较新版本，需要更新 SHA。
# 还可以引用标记或分支，但该操作可能会更改而不发出警告。

name: Publish Docker image

on:
  push:
    branches:
      - main

jobs:
  push_to_registry:
    name: Push Docker image to Docker Hub
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read
      attestations: write
      id-token: write
    steps:
      - name: Check out the repo
        uses: actions/checkout@v4

      - name: Log in to Docker Hub
        uses: docker/login-action@f4ef78c080cd8ba55a85445d5b36e214a81df20a
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Extract metadata (tags, labels) for Docker
        id: meta
        uses: docker/metadata-action@9ec57ed1fcdbf14dcef7dfbe97b2010124a938b7
        with:
          images: dsmggm/autojdck

      - name: Build and push Docker image
        id: push
        uses: docker/build-push-action@3b5e8027fcad23fda98b2e3ac259d8d67585f671
        with:
          context: .
          file: ./Dockerfile
          push: true
          tags: |
            dsmggm/autojdck:latest          # 使用latest标签
            dsmggm/autojdck:${{ github.ref_name }}  # 使用Git标签作为版本号
          labels: ${{ steps.meta.outputs.labels }}

          
