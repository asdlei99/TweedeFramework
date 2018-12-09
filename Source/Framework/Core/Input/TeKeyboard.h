#pragma once

#include "TeCorePrerequisites.h"

namespace te
{
    /** Represents a single hardware keyboard. Used by the Input to report keyboard input events. */
    class TE_CORE_EXPORT Keyboard
    {
    public:
        struct Pimpl;

        Keyboard(const String& name, Input* owner);
        ~Keyboard();

        /** Returns the name of the device. */
        const String& getName() const { return _name; }

        /** Captures the input since the last call and triggers the events on the parent Input. */
        void Capture();

    private:
        friend class Input;

        String _name;
        Input* _owner;

        Pimpl* _data;
    };
}