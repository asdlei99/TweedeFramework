set(TE_UTILITY_INC_THIRDPARTY
    "Utility/ThirdParty/Md5/md5.h"
    "Utility/ThirdParty/Json/json.h"
    "Utility/ThirdParty/TinyXml/tinyxml2.h"
)
set(TE_UTILITY_SRC_THIRDPARTY
    "Utility/ThirdParty/Md5/md5.cpp"
    "Utility/ThirdParty/TinyXml/tinyxml2.cpp"
)

set(TE_UTILITY_INC_MATH
    "Utility/Math/TeAABox.h"
    "Utility/Math/TeBounds.h"
    "Utility/Math/TeVector2.h"
    "Utility/Math/TeVector2I.h"
    "Utility/Math/TeVector3.h"
    "Utility/Math/TeVector3I.h"
    "Utility/Math/TeVector4.h"
    "Utility/Math/TeVector4I.h"
    "Utility/Math/TeMatrix3.h"
    "Utility/Math/TeMatrix4.h"
    "Utility/Math/TeRect2.h"
    "Utility/Math/TeRect2I.h"
    "Utility/Math/TeRect3.h"
    "Utility/Math/TeQuaternion.h"
    "Utility/Math/TeDegree.h"
    "Utility/Math/TeRadian.h"
    "Utility/Math/TePlane.h"
    "Utility/Math/TeSphere.h"
    "Utility/Math/TeRay.h"
    "Utility/Math/TeMath.h"
    "Utility/Math/TeLineSegment3.h"
    "Utility/Math/TeLine2.h"
)
set(TE_UTILITY_SRC_MATH
    "Utility/Math/TeAABox.cpp"
    "Utility/Math/TeBounds.cpp"
    "Utility/Math/TeVector2.cpp"
    "Utility/Math/TeVector2I.cpp"
    "Utility/Math/TeVector3.cpp"
    "Utility/Math/TeVector3I.cpp"
    "Utility/Math/TeVector4.cpp"
    "Utility/Math/TeVector4I.cpp"
    "Utility/Math/TeMatrix3.cpp"
    "Utility/Math/TeMatrix4.cpp"
    "Utility/Math/TeRect2.cpp"
    "Utility/Math/TeRect2I.cpp"
    "Utility/Math/TeRect3.cpp"
    "Utility/Math/TeQuaternion.cpp"
    "Utility/Math/TeDegree.cpp"
    "Utility/Math/TeRadian.cpp"
    "Utility/Math/TePlane.cpp"
    "Utility/Math/TeSphere.cpp"
    "Utility/Math/TeRay.cpp"
    "Utility/Math/TeMath.cpp"
    "Utility/Math/TeLineSegment3.cpp"
    "Utility/Math/TeLine2.cpp"
)

set(TE_UTILITY_INC_PREPREQUISITES
    "Utility/Prerequisites/TePrerequisitesUtility.h"
    "Utility/Prerequisites/TePlatformDefines.h"
    "Utility/Prerequisites/TeForwardDecl.h"
    "Utility/Prerequisites/TeStdHeaders.h"
    "Utility/Prerequisites/TeTypes.h"
)
set(TE_UTILITY_SRC_PREPREQUISITES
)

set(TE_UTILITY_INC_ALLOCATOR
    "Utility/Allocator/TeMemoryAllocator.h"
    "Utility/Allocator/TeBasicAllocator.h"
    "Utility/Allocator/TeLinearAllocator.h"
    "Utility/Allocator/TePoolAllocator.h"
    "Utility/Allocator/TeStackAllocator.h"
)
set(TE_UTILITY_SRC_ALLOCATOR
    "Utility/Allocator/TeBasicAllocator.cpp"
    "Utility/Allocator/TeLinearAllocator.cpp"
    "Utility/Allocator/TeStackAllocator.cpp"
)

set(TE_UTILITY_INC_ERROR
    "Utility/Error/TeConsole.h"
    "Utility/Error/TeError.h"
    "Utility/Error/TeDebug.h"
)
set(TE_UTILITY_SRC_ERROR
    "Utility/Error/TeConsole.cpp"
)

set(TE_UTILITY_INC_STRING
    "Utility/String/TeString.h"
)
set(TE_UTILITY_SRC_STRING
    "Utility/String/TeString.cpp"
)

set(TE_UTILITY_INC_UTILITY
    "Utility/Utility/TeDynLib.h"
    "Utility/Utility/TeDynLibManager.h"
    "Utility/Utility/TeModule.h"
    "Utility/Utility/TeNonCopyable.h"
    "Utility/Utility/TeTime.h"
    "Utility/Utility/TeTimer.h"
    "Utility/Utility/TeUtility.h"
    "Utility/Utility/TeUUID.h"
    "Utility/Utility/TeQueue.h"
    "Utility/Utility/TeEvent.h"
)
set(TE_UTILITY_SRC_UTILITY
    "Utility/Utility/TeDynLib.cpp"
    "Utility/Utility/TeDynLibManager.cpp"
    "Utility/Utility/TeTime.cpp"
    "Utility/Utility/TeTimer.cpp"
    "Utility/Utility/TeUtility.cpp"
    "Utility/Utility/TeUUID.cpp"
)

set(TE_UTILITY_INC_THREADING
    "Utility/Threading/TeThreading.h"
    "Utility/Threading/TeTaskScheduler.h"
    "Utility/Threading/TeThreadPool.h"
)
set(TE_UTILITY_SRC_THREADING
    "Utility/Threading/TeTaskScheduler.cpp"
    "Utility/Threading/TeThreadPool.cpp"
)

set(TE_UTILITY_INC_WIN32
)
set(TE_UTILITY_SRC_WIN32
    "Utility/Private/Win32/TeWin32PlatformUtility.cpp"
)

set(TE_UTILITY_INC_LINUX
)
set(TE_UTILITY_SRC_LINUX
    "Utility/Private/Linux/TeLinuxPlatformUtility.cpp"
)

set(TE_UTILITY_INC_MACOS
)
set(TE_UTILITY_SRC_MACOS
    "Utility/Private/MacOS/TeMacOSPlatformUtility.cpp"
)

if(WIN32)
	list(APPEND TE_UTILITY_SRC_UTILITY ${TE_UTILITY_SRC_WIN32})
	list(APPEND TE_UTILITY_INC_UTILITY ${TE_UTILITY_INC_WIN32})
elseif(LINUX)
    list(APPEND TE_UTILITY_SRC_UTILITY ${TE_UTILITY_SRC_LINUX})
    list(APPEND TE_UTILITY_INC_UTILITY ${TE_UTILITY_INC_LINUX})
elseif(APPLE)
    list(APPEND TE_UTILITY_SRC_UTILITY ${TE_UTILITY_SRC_MACOS})
    list(APPEND TE_UTILITY_INC_UTILITY ${TE_UTILITY_INC_MACOS})
endif()

source_group("Utility\\ThirdParty" FILES ${TE_UTILITY_INC_THIRDPARTY} ${TE_UTILITY_SRC_THIRDPARTY})
source_group("Utility\\Math" FILES ${TE_UTILITY_INC_MATH} ${TE_UTILITY_SRC_MATH})
source_group("Utility\\Prerequisites" FILES ${TE_UTILITY_INC_PREPREQUISITES} ${TE_UTILITY_SRC_PREPREQUISITES})
source_group("Utility\\Allocator" FILES ${TE_UTILITY_INC_ALLOCATOR} ${TE_UTILITY_SRC_ALLOCATOR})
source_group("Utility\\Error" FILES ${TE_UTILITY_INC_ERROR} ${TE_UTILITY_SRC_ERROR})
source_group("Utility\\String" FILES ${TE_UTILITY_INC_STRING} ${TE_UTILITY_SRC_STRING})
source_group("Utility\\Utility" FILES ${TE_UTILITY_INC_UTILITY} ${TE_UTILITY_SRC_UTILITY})
source_group("Utility\\Threading" FILES ${TE_UTILITY_INC_THREADING} ${TE_UTILITY_SRC_THREADING})

set(TE_UTILITY_SRC
    ${TE_UTILITY_SRC_MATH}
    ${TE_UTILITY_INC_MATH}
    ${TE_UTILITY_SRC_THIRDPARTY}
    ${TE_UTILITY_INC_THIRDPARTY}
    ${TE_UTILITY_SRC_PREPREQUISITES}
    ${TE_UTILITY_INC_PREPREQUISITES}
    ${TE_UTILITY_SRC_ALLOCATOR}
    ${TE_UTILITY_INC_ALLOCATOR}
    ${TE_UTILITY_SRC_ERROR}
    ${TE_UTILITY_INC_ERROR}
    ${TE_UTILITY_SRC_STRING}
    ${TE_UTILITY_INC_STRING}
    ${TE_UTILITY_SRC_UTILITY}
    ${TE_UTILITY_INC_UTILITY}
    ${TE_UTILITY_SRC_THREADING}
    ${TE_UTILITY_INC_THREADING}
)