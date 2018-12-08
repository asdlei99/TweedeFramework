#include "Manager/TeRendererManager.h"
#include "Renderer/TeRenderer.h"
#include "Renderer/TeRendererFactory.h"
#include "Utility/TeDynLib.h"
#include "Utility/TeDynLibManager.h"

namespace te
{
    SPtr<Renderer> RendererManager::Initialize(const String& pluginFilename)
    {
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
                SPtr<Renderer> newRenderer = (*iter)->Create();
                if (newRenderer != nullptr)
                {
                    if (_renderer != nullptr)
                        te_delete(&_renderer);

                    _renderer = newRenderer;
                    return _renderer;
                }
            }
        }

        TE_ASSERT_ERROR(_renderer != nullptr, "Cannot initialize renderer. Renderer with the name '" + pluginFilename + "' cannot be found.");

        return nullptr;
    }

    void RendererManager::RegisterFactory(SPtr<RendererFactory> factory)
    {
        assert(factory != nullptr);

        _availableFactories.push_back(factory);
    }
}