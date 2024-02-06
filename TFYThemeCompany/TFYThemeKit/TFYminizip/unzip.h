
#ifndef _unz64_H
#define _unz64_H

#ifdef __cplusplus
extern "C" {
#endif

#ifndef _ZLIB_H
#include "zlib.h"
#endif

#ifndef  _ZLIBIOAPI_H
#include "ioapi.h"
#endif

#ifdef HAVE_BZIP2
#include "bzlib.h"
#endif

#define Z_BZIP2ED 12

#if defined(STRICTUNZIP) || defined(STRICTZIPUNZIP)
/* like the STRICT of WIN32, we define a pointer that cannot be converted
    from (void*) without cast */
typedef struct TagunzFile__ { int unused; } unzFile__;
typedef unzFile__ *unzFile;
#else
typedef voidp unzFile;
#endif


#define UNZ_OK                          (0)
#define UNZ_END_OF_LIST_OF_FILE         (-100)
#define UNZ_ERRNO                       (Z_ERRNO)
#define UNZ_EOF                         (0)
#define UNZ_PARAMERROR                  (-102)
#define UNZ_BADZIPFILE                  (-103)
#define UNZ_INTERNALERROR               (-104)
#define UNZ_CRCERROR                    (-105)

/* tm_unz contain date/time info */
typedef struct tm_unz_s
{
    uInt tm_sec;            /* seconds after the minute - [0,59] */
    uInt tm_min;            /* minutes after the hour - [0,59] */
    uInt tm_hour;           /* hours since midnight - [0,23] */
    uInt tm_mday;           /* day of the month - [1,31] */
    uInt tm_mon;            /* months since January - [0,11] */
    uInt tm_year;           /* years - [1980..2044] */
} tm_unz;

/* unz_global_info structure contain global data about the ZIPfile
   These data comes from the end of central dir */
typedef struct unz_global_info64_s
{
    ZPOS64_T number_entry;         /* total number of entries in
                                     the central dir on this disk */
    uLong size_comment;         /* size of the global comment of the zipfile */
} unz_global_info64;

typedef struct unz_global_info_s
{
    uLong number_entry;         /* total number of entries in
                                     the central dir on this disk */
    uLong size_comment;         /* size of the global comment of the zipfile */
} unz_global_info;

/* unz_file_info contain information about a file in the zipfile */
typedef struct unz_file_info64_s
{
    uLong version;              /* version made by                 2 bytes */
    uLong version_needed;       /* version needed to extract       2 bytes */
    uLong flag;                 /* general purpose bit flag        2 bytes */
    uLong compression_method;   /* compression method              2 bytes */
    uLong dosDate;              /* last mod file date in Dos fmt   4 bytes */
    uLong crc;                  /* crc-32                          4 bytes */
    ZPOS64_T compressed_size;   /* compressed size                 8 bytes */
    ZPOS64_T uncompressed_size; /* uncompressed size               8 bytes */
    uLong size_filename;        /* filename length                 2 bytes */
    uLong size_file_extra;      /* extra field length              2 bytes */
    uLong size_file_comment;    /* file comment length             2 bytes */

    uLong disk_num_start;       /* disk number start               2 bytes */
    uLong internal_fa;          /* internal file attributes        2 bytes */
    uLong external_fa;          /* external file attributes        4 bytes */

    tm_unz tmu_date;
} unz_file_info64;

typedef struct unz_file_info_s
{
    uLong version;              /* version made by                 2 bytes */
    uLong version_needed;       /* version needed to extract       2 bytes */
    uLong flag;                 /* general purpose bit flag        2 bytes */
    uLong compression_method;   /* compression method              2 bytes */
    uLong dosDate;              /* last mod file date in Dos fmt   4 bytes */
    uLong crc;                  /* crc-32                          4 bytes */
    uLong compressed_size;      /* compressed size                 4 bytes */
    uLong uncompressed_size;    /* uncompressed size               4 bytes */
    uLong size_filename;        /* filename length                 2 bytes */
    uLong size_file_extra;      /* extra field length              2 bytes */
    uLong size_file_comment;    /* file comment length             2 bytes */

    uLong disk_num_start;       /* disk number start               2 bytes */
    uLong internal_fa;          /* internal file attributes        2 bytes */
    uLong external_fa;          /* external file attributes        4 bytes */

    tm_unz tmu_date;
} unz_file_info;

extern int ZEXPORT unzStringFileNameCompare OF ((const char* fileName1,
                                                 const char* fileName2,
                                                 int iCaseSensitivity));
/*
   Compare two filename (fileName1,fileName2).
   If iCaseSenisivity = 1, comparision is case sensitivity (like strcmp)
   If iCaseSenisivity = 2, comparision is not case sensitivity (like strcmpi
                                or strcasecmp)
   If iCaseSenisivity = 0, case sensitivity is defaut of your operating system
    (like 1 on Unix, 2 on Windows)
*/


extern unzFile ZEXPORT unzOpen OF((const char *path));
extern unzFile ZEXPORT unzOpen64 OF((const void *path));

extern unzFile ZEXPORT unzOpen2 OF((const char *path,
                                    zlib_filefunc_def* pzlib_filefunc_def));

extern unzFile ZEXPORT unzOpen2_64 OF((const void *path,
                                    zlib_filefunc64_def* pzlib_filefunc_def));

extern int ZEXPORT unzClose OF((unzFile file));

extern int ZEXPORT unzGetGlobalInfo OF((unzFile file,
                                        unz_global_info *pglobal_info));

extern int ZEXPORT unzGetGlobalInfo64 OF((unzFile file,
                                        unz_global_info64 *pglobal_info));

extern int ZEXPORT unzGetGlobalComment OF((unzFile file,
                                           char *szComment,
                                           uLong uSizeBuf));

extern int ZEXPORT unzGoToFirstFile OF((unzFile file));


extern int ZEXPORT unzGoToNextFile OF((unzFile file));

extern int ZEXPORT unzLocateFile OF((unzFile file,
                     const char *szFileName,
                     int iCaseSensitivity));

typedef struct unz_file_pos_s
{
    uLong pos_in_zip_directory;   /* offset in zip file directory */
    uLong num_of_file;            /* # of file */
} unz_file_pos;

extern int ZEXPORT unzGetFilePos(
    unzFile file,
    unz_file_pos* file_pos);

extern int ZEXPORT unzGoToFilePos(
    unzFile file,
    unz_file_pos* file_pos);

typedef struct unz64_file_pos_s
{
    ZPOS64_T pos_in_zip_directory;   /* offset in zip file directory */
    ZPOS64_T num_of_file;            /* # of file */
} unz64_file_pos;

extern int ZEXPORT unzGetFilePos64(
    unzFile file,
    unz64_file_pos* file_pos);

extern int ZEXPORT unzGoToFilePos64(
    unzFile file,
    const unz64_file_pos* file_pos);

/* ****************************************** */

extern int ZEXPORT unzGetCurrentFileInfo64 OF((unzFile file,
                         unz_file_info64 *pfile_info,
                         char *szFileName,
                         uLong fileNameBufferSize,
                         void *extraField,
                         uLong extraFieldBufferSize,
                         char *szComment,
                         uLong commentBufferSize));

extern int ZEXPORT unzGetCurrentFileInfo OF((unzFile file,
                         unz_file_info *pfile_info,
                         char *szFileName,
                         uLong fileNameBufferSize,
                         void *extraField,
                         uLong extraFieldBufferSize,
                         char *szComment,
                         uLong commentBufferSize));

extern ZPOS64_T ZEXPORT unzGetCurrentFileZStreamPos64 OF((unzFile file));


extern int ZEXPORT unzOpenCurrentFile OF((unzFile file));

extern int ZEXPORT unzOpenCurrentFilePassword OF((unzFile file,
                                                  const char* password));

extern int ZEXPORT unzOpenCurrentFile2 OF((unzFile file,
                                           int* method,
                                           int* level,
                                           int raw));

extern int ZEXPORT unzOpenCurrentFile3 OF((unzFile file,
                                           int* method,
                                           int* level,
                                           int raw,
                                           const char* password));

extern int ZEXPORT unzCloseCurrentFile OF((unzFile file));

extern int ZEXPORT unzReadCurrentFile OF((unzFile file,
                      voidp buf,
                      unsigned len));

extern z_off_t ZEXPORT unztell OF((unzFile file));

extern ZPOS64_T ZEXPORT unztell64 OF((unzFile file));
/*
  Give the current position in uncompressed data
*/

extern int ZEXPORT unzeof OF((unzFile file));
/*
  return 1 if the end of file was reached, 0 elsewhere
*/

extern int ZEXPORT unzGetLocalExtrafield OF((unzFile file,
                                             voidp buf,
                                             unsigned len));

/* Get the current file offset */
extern ZPOS64_T ZEXPORT unzGetOffset64 (unzFile file);
extern uLong ZEXPORT unzGetOffset (unzFile file);

/* Set the current file offset */
extern int ZEXPORT unzSetOffset64 (unzFile file, ZPOS64_T pos);
extern int ZEXPORT unzSetOffset (unzFile file, uLong pos);



#ifdef __cplusplus
}
#endif

#endif /* _unz64_H */
