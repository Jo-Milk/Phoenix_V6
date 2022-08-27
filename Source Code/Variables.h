#define SCRIPTS_PATH "/dev_hdd0/tmp/Jo-Milk"

#define MAX_GSC_COUNT 100

typedef struct opd32
{
    void *function;
    int toc;
} opd32;
typedef struct opd32 *popd32;


typedef struct scrChecksum_t
{
    int checksum;
    int programLen;
    int substract;
} scrChecksum_t;

typedef enum scriptInstance_t
{
    SCRIPTINSTANCE_SERVER = 0,
    SCRIPTINSTANCE_CLIENT = 1,
    SCRIPT_INSTANCE_MAX = 2
} scriptInstance_t;

typedef void UiContext;

struct VariableStackBuffer {
	const char *pos;
	unsigned short size;
	unsigned short bufLen;
	unsigned int localId;
	char time;
	char buf[1];
};

union VariableUnion {
	int intValue;
	float floatValue;
	unsigned int stringValue;
	float *vectorValue;
	const char *codePosValue;
	unsigned int pointerValue;
	VariableStackBuffer *stackValue;
	unsigned int entityOffset;
};

struct VariableValue {
	VariableUnion u;
	int type;
};

typedef enum XAssetType
{
    ASSET_TYPE_RAWFILE = 0x26
} XAssetType;

typedef union XAssetHeader
{
    struct RawFile *rawFile;
    void *data;
} XAssetHeader;

typedef struct XAsset
{
    enum XAssetType type;
    union XAssetHeader header;
} XAsset;

typedef struct XAssetEntry
{
    XAsset asset;
    char zoneIndex;
    bool inuse;
    uint16_t nextHash;
    uint16_t nextOverride;
    uint16_t usageFrame;
    char margin[0x10];
} XAssetEntry;



typedef union XAssetEntryPoolEntry
{
    struct XAssetEntry entry;
    union XAssetEntryPoolEntry *next;
} XAssetEntryPoolEntry;

typedef union DvarValue
{
    bool enabled;
    int integer;
    uint32_t unsignedInt;
    int64_t integer64;
    uint64_t unsignedInt64;
    float value;
    float vector[4];
    const char *string;
    char color[4];
} DvarValue;

typedef enum dvarType_t
{
    DVAR_TYPE_BOOL = 0x0,
    DVAR_TYPE_FLOAT = 0x1,
    DVAR_TYPE_FLOAT_2 = 0x2,
    DVAR_TYPE_FLOAT_3 = 0x3,
    DVAR_TYPE_FLOAT_4 = 0x4,
    DVAR_TYPE_INT = 0x5,
    DVAR_TYPE_ENUM = 0x6,
    DVAR_TYPE_STRING = 0x7,
    DVAR_TYPE_COLOR = 0x8,
    DVAR_TYPE_INT64 = 0x9,
    DVAR_TYPE_LINEAR_COLOR_RGB = 0xA,
    DVAR_TYPE_COLOR_XYZ = 0xB,
    DVAR_TYPE_COUNT = 0xC
} dvarType_t;

typedef struct dvar_s
{
    const char *name;
    const char *description;
    int hash;
    unsigned int flags;
    dvarType_t type;
    bool modified;
    bool loadedFromSaveGame;
    DvarValue current;
    DvarValue latched;
    DvarValue reset;
    DvarValue saved;
    char domain[10];
    struct dvar_s *hashNext;
} dvar_s;

typedef struct RawFileData
{
    char name[100];
    int inflatedSize;
    int size;
    char buffer[0x20];
} RawFileData;

typedef struct RawFile
{
    char *name;
    int len;
    char *buffer;
} RawFile;

typedef struct GSCLoaderRawfile
{
    XAssetEntry entry;
    RawFile asset;
    RawFileData data;
} GSCLoaderRawfile;


typedef struct GSCLoader
{
    char currentModName[256];
    GSCLoaderRawfile rawFiles[MAX_GSC_COUNT];
} GSCLoader;

GSCLoader loader;
scrChecksum_t checksums[3];
int modHandle;
int modHandlecsc;

typedef struct scrVarPub_t
{
    char _unsafe[0x38];
    int checksum;
    int entId;
    int entFieldName;
    char *programHunkUser;
    char *programBuffer;
    char *endScriptBuffer;
    char _unsafe2[0x0C];
} scrVarPub_t; // 0x58

typedef struct scrCompilePub_t
{
    char _unsafe[0x20030];
    int programLen;
    char _unsafe2[0x1004];
} scrCompilePub_t; // 0x21038

extern scrVarPub_t *scrVarPub;
scrVarPub_t* scrVarPub = (scrVarPub_t*)0x1AE9600;

extern scrCompilePub_t *scrCompilePub;
scrCompilePub_t* scrCompilePub = (scrCompilePub_t*)0x1846C88;


typedef struct InflateData
{
    char *deflatedBuffer;
    char *hunkMemoryBuffer;
    char _unsafe[0x18];
} InflateData; // 0x20? (unknown structure, ps3 only)