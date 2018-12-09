#include "Manager/TeRenderAPIManager.h"
#include "RenderAPI/TeRenderAPI.h"
#include "RenderAPI/TeRenderAPIFactory.h"
#include "Utility/TeDynLib.h"
#include "Utility/TeDynLibManager.h"

namespace te
{
    RenderAPIManager::RenderAPIManager()
        : _renderAPIInitialized(false)
    { }

    RenderAPIManager::~RenderAPIManager()
    {
    }

    void RenderAPIManager::Initialize(const String& pluginFilename, const RENDER_WINDOW_DESC& windowDesc)
    {
        if (_renderAPIInitialized)
            return;

        DynLib* loadedLibrary = gDynLibManager().Load(pluginFilename);
        const char* name = "";

        if (loadedLibrary != nullptr)
        {
            typedef const char* (*GetPluginNameFunc)();

            GetPluginNameFunc getPluginNameFunc = (GetPluginNameFunc)loadedLibrary->GetSymbol("GetPluginName");
            name = getPluginNameFunc();
        }

        for (auto iter = _availableFactories.begin(); iter != _availableFactories.end(); ++iter)
        {
            if ((*iter)->Name() == name)
            {
                (*iter)->Create();
            }
        }
    }

    void RenderAPIManager::RegisterFactory(SPtr<RenderAPIFactory> factory)
    {
        assert(factory != nullptr);

        _availableFactories.push_back(factory);
    }
}