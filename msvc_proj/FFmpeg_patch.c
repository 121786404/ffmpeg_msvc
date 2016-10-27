#include "..\FFmpeg\libavresample\version.h"
#include "..\FFmpeg\libpostproc\version.h"
#include "..\FFmpeg\libavutil\avassert.h"
#include "..\FFmpeg\config.h"


unsigned avresample_version(void)
{
    return LIBAVRESAMPLE_VERSION_INT;
}

const char *avresample_configuration(void)
{
    return FFMPEG_CONFIGURATION;
}

unsigned postproc_version(void)
{
    av_assert0(LIBPOSTPROC_VERSION_MICRO >= 100);
    return LIBPOSTPROC_VERSION_INT;
}

const char *postproc_configuration(void)
{
    return FFMPEG_CONFIGURATION;
}

