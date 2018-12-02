function (strip_symbols targetName outputFilename)
    if (UNIX)
        if (CMAKE_BUILD_TYPE STREQUAL Release)
            set(fileToStrip $<TARGET_FILE:${targetName}>)

            # macOS
            if (CMAKE_SYSTEM_NAME STREQUAL Darwin)
                set(symbolsFile ${fileToStrip}.dwarf)

                add_custom_command (
                    TARGET ${targetName}
                    POST_BUILD
                    VERBATIM 
                    COMMAND ${DSYMUTIL_TOOL} --flat --minimize ${fileToStrip}
                    COMMAND ${STRIP_TOOL} -u -r ${fileToStrip}
                    COMMENT Stripping symbols from ${fileToStrip} into file ${symbolsFile}
                )
            
            # Linux
            else ()
                set(symbolsFile ${fileToStrip}.dbg)

                add_custom_command (
                    TARGET ${targetName}
                    POST_BUILD
                    VERBATIM 
                    COMMAND ${OBJCOPY_TOOL} --only-keep-debug ${fileToStrip} ${symbolsFile}
                    COMMAND ${OBJCOPY_TOOL} --strip-unneeded ${fileToStrip}
                    COMMAND ${OBJCOPY_TOOL} --add-gnu-debuglink=${symbolsFile} ${fileToStrip}
                    COMMENT Stripping symbols from ${fileToStrip} into file ${symbolsFile}
                )
            endif (CMAKE_SYSTEM_NAME STREQUAL Darwin)

            set (${outputFilename} ${symbolsFile} PARENT_SCOPE)
        endif ()
    endif ()
endfunction ()

function (install_tef_target targetName)
    strip_symbols (${targetName} symbolsFile)
    
    install(
        TARGETS ${targetName}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
    )       
    
    if (MSVC)
        install(
            FILES $<TARGET_PDB_FILE:${targetName}> 
            DESTINATION bin 
            OPTIONAL
        )
    else ()
        install(
            FILES ${symbolsFile} 
            DESTINATION lib
            OPTIONAL)
    endif ()
endfunction()

function (target_link_framework TARGET FRAMEWORK)
    find_library (FM_${FRAMEWORK} ${FRAMEWORK})

    if (NOT FM_${FRAMEWORK})
        message (FATAL_ERROR "Cannot find ${FRAMEWORK} framework.")
    endif ()

    target_link_libraries (${TARGET} PRIVATE ${FM_${FRAMEWORK}})
    mark_as_advanced (FM_${FRAMEWORK})
endfunction ()

MACRO (start_find_package FOLDER_NAME)
    message (STATUS "Looking for ${FOLDER_NAME} installation...")
ENDMACRO ()

# Generates a set of variables pointing to the default locations for library's includes and binaries.
# Must be defined before calling:
#  - ${LIB_NAME}_INSTALL_DIR
#
# Will define:
#  - ${LIB_NAME}_INCLUDE_SEARCH_DIRS
#  - ${LIB_NAME}_LIBRARY_RELEASE_SEARCH_DIRS
#  - ${LIB_NAME}_LIBRARY_DEBUG_SEARCH_DIRS
MACRO (gen_default_lib_search_dirs LIB_NAME)
    set (${LIB_NAME}_INCLUDE_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/include")

    if (TE_64BIT)
        list (APPEND ${LIB_NAME}_LIBRARY_RELEASE_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib/x64/Release")
        list (APPEND ${LIB_NAME}_LIBRARY_DEBUG_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib/x64/Debug")
    else ()
        list (APPEND ${LIB_NAME}_LIBRARY_RELEASE_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib/x86/Release")
        list (APPEND ${LIB_NAME}_LIBRARY_DEBUG_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib/x86/Debug")
    endif ()

    # Allow for paths without a configuration specified
    if (TE_64BIT)
        list (APPEND ${LIB_NAME}_LIBRARY_RELEASE_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib/x64")
        list (APPEND ${LIB_NAME}_LIBRARY_DEBUG_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib/x64")
    else ()
        list (APPEND ${LIB_NAME}_LIBRARY_RELEASE_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib/x86")
        list (APPEND ${LIB_NAME}_LIBRARY_DEBUG_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib/x86") 
    endif ()
    
    # Allow for paths without a platform specified
    list (APPEND ${LIB_NAME}_LIBRARY_RELEASE_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib/Release")
    list (APPEND ${LIB_NAME}_LIBRARY_DEBUG_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib/Debug")

    # Allow for paths without a platform or configuration specified
    list (APPEND ${LIB_NAME}_LIBRARY_RELEASE_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib")
    list (APPEND ${LIB_NAME}_LIBRARY_DEBUG_SEARCH_DIRS "${${LIB_NAME}_INSTALL_DIR}/lib")
ENDMACRO ()

MACRO (find_imported_includes FOLDER_NAME INCLUDE_FILES)
    find_path (${FOLDER_NAME}_INCLUDE_DIR NAMES ${INCLUDE_FILES} PATHS ${${FOLDER_NAME}_INCLUDE_SEARCH_DIRS} NO_DEFAULT_PATH)
    find_path (${FOLDER_NAME}_INCLUDE_DIR NAMES ${INCLUDE_FILES} PATHS ${${FOLDER_NAME}_INCLUDE_SEARCH_DIRS})
    
    if (${FOLDER_NAME}_INCLUDE_DIR)
        set (${FOLDER_NAME}_FOUND TRUE)
    else ()
        message (STATUS "...Cannot find include file \"${INCLUDE_FILES}\" at path ${${FOLDER_NAME}_INCLUDE_SEARCH_DIRS}")
        set (${FOLDER_NAME}_FOUND FALSE)
    endif ()
ENDMACRO ()

MACRO (find_imported_library2 FOLDER_NAME LIB_NAME DEBUG_LIB_NAME)
    find_imported_library3 (${FOLDER_NAME} ${LIB_NAME} ${DEBUG_LIB_NAME} FALSE)
ENDMACRO ()

MACRO (find_imported_library FOLDER_NAME LIB_NAME)
    find_imported_library2 (${FOLDER_NAME} ${LIB_NAME} ${LIB_NAME})
ENDMACRO ()

MACRO (find_imported_library3 FOLDER_NAME LIB_NAME DEBUG_LIB_NAME IS_SHARED)
    find_library (${LIB_NAME}_LIBRARY_RELEASE NAMES ${LIB_NAME} PATHS ${${FOLDER_NAME}_LIBRARY_RELEASE_SEARCH_DIRS} NO_DEFAULT_PATH)
    find_library (${LIB_NAME}_LIBRARY_RELEASE NAMES ${LIB_NAME} PATHS ${${FOLDER_NAME}_LIBRARY_RELEASE_SEARCH_DIRS})
    
    if (${FOLDER_NAME}_LIBRARY_DEBUG_SEARCH_DIRS)
        find_library (${LIB_NAME}_LIBRARY_DEBUG NAMES ${DEBUG_LIB_NAME} PATHS ${${FOLDER_NAME}_LIBRARY_DEBUG_SEARCH_DIRS} NO_DEFAULT_PATH)
        find_library (${LIB_NAME}_LIBRARY_DEBUG NAMES ${DEBUG_LIB_NAME} PATHS ${${FOLDER_NAME}_LIBRARY_DEBUG_SEARCH_DIRS})
    else ()
        find_library (${LIB_NAME}_LIBRARY_DEBUG NAMES ${DEBUG_LIB_NAME} PATHS ${${FOLDER_NAME}_LIBRARY_RELEASE_SEARCH_DIRS} NO_DEFAULT_PATH)
        find_library (${LIB_NAME}_LIBRARY_DEBUG NAMES ${DEBUG_LIB_NAME} PATHS ${${FOLDER_NAME}_LIBRARY_RELEASE_SEARCH_DIRS})
    endif ()

    if (${LIB_NAME}_LIBRARY_RELEASE)
        if (${LIB_NAME}_LIBRARY_DEBUG)
            add_imported_library (${FOLDER_NAME}::${LIB_NAME} "${${LIB_NAME}_LIBRARY_RELEASE}"
                "${${LIB_NAME}_LIBRARY_DEBUG}" ${IS_SHARED})
        else ()
            add_imported_library (${FOLDER_NAME}::${LIB_NAME} "${${LIB_NAME}_LIBRARY_RELEASE}"
                "${${LIB_NAME}_LIBRARY_RELEASE}" ${IS_SHARED})
        endif ()
    else ()
        set (${FOLDER_NAME}_FOUND FALSE)
        message (STATUS "...Cannot find imported library: ${LIB_NAME} ${${LIB_NAME}_LIBRARY_RELEASE}")
    endif ()

    list (APPEND ${FOLDER_NAME}_LIBRARIES ${FOLDER_NAME}::${LIB_NAME})
    mark_as_advanced (${LIB_NAME}_LIBRARY_RELEASE ${LIB_NAME}_LIBRARY_DEBUG)
ENDMACRO ()

MACRO (find_imported_library_shared2 FOLDER_NAME LIB_NAME DEBUG_LIB_NAME)
    list (APPEND ${FOLDER_NAME}_SHARED_LIBS ${LIB_NAME})
    find_imported_library3 (${FOLDER_NAME} ${LIB_NAME} ${DEBUG_LIB_NAME} TRUE)
ENDMACRO ()

MACRO (find_imported_library_shared FOLDER_NAME LIB_NAME)
    list (APPEND ${FOLDER_NAME}_SHARED_LIBS ${LIB_NAME})
    find_imported_library_shared2 (${FOLDER_NAME} ${LIB_NAME} ${LIB_NAME})
ENDMACRO ()

MACRO (start_find_package FOLDER_NAME)
    message (STATUS "Looking for ${FOLDER_NAME} installation...")
ENDMACRO ()

MACRO (end_find_package FOLDER_NAME MAIN_LIB_NAME)
    if (NOT ${FOLDER_NAME}_FOUND)
        if (${FOLDER_NAME}_FIND_REQUIRED)
            message (FATAL_ERROR "Cannot find ${FOLDER_NAME} installation. Try modifying the ${FOLDER_NAME}_INSTALL_DIR path.")
        elseif (NOT ${FOLDER_NAME}_FIND_QUIETLY)
            message (WARNING "Cannot find ${FOLDER_NAME} installation. Try modifying the ${FOLDER_NAME}_INSTALL_DIR path.")
        endif ()
    else ()
        set_target_properties (${FOLDER_NAME}::${MAIN_LIB_NAME} PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${${FOLDER_NAME}_INCLUDE_DIR}")
        message (STATUS "...${FOLDER_NAME} OK.")
    endif ()

    mark_as_advanced (${FOLDER_NAME}_INSTALL_DIR ${FOLDER_NAME}_INCLUDE_DIR)
    set (${FOLDER_NAME}_INCLUDE_DIRS ${${FOLDER_NAME}_INCLUDE_DIR})
ENDMACRO ()

MACRO (add_imported_library LIB_NAME RELEASE_NAME DEBUG_NAME IS_SHARED)
    if (${IS_SHARED} AND NOT WIN32)
        add_library (${LIB_NAME} SHARED IMPORTED)
    else ()
        add_library (${LIB_NAME} STATIC IMPORTED)
    endif ()

    if (CMAKE_CONFIGURATION_TYPES) # Multiconfig generator?
        set_target_properties (${LIB_NAME} PROPERTIES IMPORTED_LOCATION_DEBUG "${DEBUG_NAME}")
        set_target_properties (${LIB_NAME} PROPERTIES IMPORTED_LOCATION_RELWITHDEBINFO "${RELEASE_NAME}")
        set_target_properties (${LIB_NAME} PROPERTIES IMPORTED_LOCATION_MINSIZEREL "${RELEASE_NAME}")
        set_target_properties (${LIB_NAME} PROPERTIES IMPORTED_LOCATION_RELEASE "${RELEASE_NAME}")
    else ()
        set_target_properties (${LIB_NAME} PROPERTIES IMPORTED_LOCATION "${RELEASE_NAME}")
    endif ()
ENDMACRO ()

MACRO (install_dependency_binaries FOLDER_NAME)
    foreach (LOOP_ENTRY ${${FOLDER_NAME}_SHARED_LIBS})
        get_filename_component (RELEASE_FILENAME ${${LOOP_ENTRY}_LIBRARY_RELEASE} NAME_WE)
        get_filename_component (DEBUG_FILENAME ${${LOOP_ENTRY}_LIBRARY_DEBUG} NAME_WE)
        
        if (WIN32)
            if (TE_64BIT)
                set (PLATFORM "x64")
            else ()
                set (PLATFORM "x86")
            endif ()
            
            if (RELEASE_FILENAME STREQUAL libFLAC)
                set (RELEASE_FILENAME libFLAC_dynamic.dll)
                set (DEBUG_FILENAME libFLAC_dynamic.dll)
            else ()
                set (RELEASE_FILENAME ${RELEASE_FILENAME}.dll)
                set (DEBUG_FILENAME ${DEBUG_FILENAME}.dll)
            endif ()
            
            set (SRC_RELEASE "${PROJECT_SOURCE_DIR}/Dependencies/binaries/${PLATFORM}/Release/${RELEASE_FILENAME}")
            set (SRC_DEBUG "${PROJECT_SOURCE_DIR}/Dependencies/binaries/${PLATFORM}/Debug/${DEBUG_FILENAME}")
            set (DESTINATION_DIR bin/)
        else ()
            set (RELEASE_FILENAME ${RELEASE_FILENAME}.so)
            set (DEBUG_FILENAME ${DEBUG_FILENAME}.so)

            set (SRC_RELEASE ${${LOOP_ENTRY}_LIBRARY_RELEASE})
            set (SRC_DEBUG ${${LOOP_ENTRY}_LIBRARY_DEBUG})
            set (DESTINATION_DIR lib)
        endif ()

        execute_process (COMMAND ${CMAKE_COMMAND} -E make_directory "${PROJECT_SOURCE_DIR}/${DESTINATION_DIR}${PLATFORM}/Release/")
        execute_process (COMMAND ${CMAKE_COMMAND} -E make_directory "${PROJECT_SOURCE_DIR}/${DESTINATION_DIR}${PLATFORM}/RelWithDebInfo/")
        execute_process (COMMAND ${CMAKE_COMMAND} -E make_directory "${PROJECT_SOURCE_DIR}/${DESTINATION_DIR}${PLATFORM}/MinSizeRel/")
        execute_process (COMMAND ${CMAKE_COMMAND} -E make_directory "${PROJECT_SOURCE_DIR}/${DESTINATION_DIR}${PLATFORM}/Debug/")

        execute_process (COMMAND ${CMAKE_COMMAND} -E copy ${SRC_RELEASE} "${PROJECT_SOURCE_DIR}/${DESTINATION_DIR}${PLATFORM}/Release/")
        execute_process (COMMAND ${CMAKE_COMMAND} -E copy ${SRC_RELEASE} "${PROJECT_SOURCE_DIR}/${DESTINATION_DIR}${PLATFORM}/RelWithDebInfo/")
        execute_process (COMMAND ${CMAKE_COMMAND} -E copy ${SRC_RELEASE} "${PROJECT_SOURCE_DIR}/${DESTINATION_DIR}${PLATFORM}/MinSizeRel/")
        execute_process (COMMAND ${CMAKE_COMMAND} -E copy ${SRC_DEBUG}   "${PROJECT_SOURCE_DIR}/${DESTINATION_DIR}${PLATFORM}/Debug/")
    endforeach ()
ENDMACRO ()