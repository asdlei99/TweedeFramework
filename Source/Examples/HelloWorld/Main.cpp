#include "TeCoreApplication.h"

#if TE_PLATFORM == TE_PLATFORM_WIN32
#include <windows.h>

int CALLBACK WinMain(
    _In_  HINSTANCE hInstance,
    _In_  HINSTANCE hPrevInstance,
    _In_  LPSTR lpCmdLine,
    _In_  int nCmdShow
)
#else
int main()
#endif
{
    te::START_UP_DESC desc;

    desc.RenderAPI = TE_RENDER_API_MODULE;
    desc.Renderer = TE_RENDERER_MODULE;
    desc.Physics = TE_PHYSICS_MODULE;
    desc.Audio = TE_AUDIO_MODULE;

    desc.Importers = {
        "TeFontImporter",
        "TeFreeImgImporter",
        "TeObjectImporter"
    };

    desc.WindowDesc;

    te::CoreApplication::StartUp(desc);

    te::String hello = "Hello World!";
    std::cout << hello << std::endl;

    te::gCoreApplication().RunMainLoop();
    te::CoreApplication::ShutDown();

    return 0;
}
