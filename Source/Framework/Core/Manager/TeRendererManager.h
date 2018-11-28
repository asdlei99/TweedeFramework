#pragma once

#include "TeCorePrerequisites.h"
#include "Utility/TeModule.h"
#include "Renderer/TeRenderer.h"
#include "Renderer/TeRendererFactory.h"

namespace te
{
    /** Manager that handles render system start up. */
    class TE_CORE_EXPORT RendererManager : public Module<RendererManager>
    {
    public:
        /** Initializes the renderer, making it ready to render. */
        void Initialize(const String& pluginFilename);

        /**	Returns the current renderer. Null if no renderer is active. */
        SPtr<Renderer> GetRenderer() { return _renderer; }

        /**	Registers a new render API factory responsible for creating a specific render system type. */
        void RegisterFactory(SPtr<RendererFactory> factory);
    private:
        Vector<SPtr<RendererFactory>> _availableFactories;
        SPtr<Renderer> _renderer;
    };

    /** @} */
}