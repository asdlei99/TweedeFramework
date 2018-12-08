#include "Input/TeMouse.h"
#include "Input/TeInput.h"
#include "Private/MacOS/TeMacOSInput.h"

namespace te
{
    Mouse::Mouse(const String& name, Input* owner)
        : _name(name), _owner(owner)
    {
    }

    Mouse::~Mouse()
    {
    }
}