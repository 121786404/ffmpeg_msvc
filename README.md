## 1. 下载 ##

	git clone --recursive https://github.com/121786404/ffmpeg_msvc

## 2. 编译ffmpeg和ffplay ##

	build_win32d.bat 编译ffmpeg

	打开msvc_proj/ffmpegvs.sln 编译ffplay和ffmpeg



目前ffmpeg 3.2 使用SDL 2.0 有问题

请先使用ffmpeg 3.1  使用SDL 1.2    git reset --hard n3.1.5
