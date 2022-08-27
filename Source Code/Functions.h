
struct opd_s
{
	int32_t sub;
	int32_t toc;
};
opd_s va_t = { 0x4DB3D8, TOC };
char *(*va)(const char *format, ...) = (char *(*)(const char *, ...))&va_t;

opd_s DB_FindXAssetHeader_t = { 0x1B1E20, TOC };
XAssetHeader *(*DB_FindXAssetHeader)(XAssetHeader *header, XAssetType type, const char *name, bool errorIfMissing, int waitTime) = (XAssetHeader *(*)(XAssetHeader *, XAssetType, const char *, bool ,int))&DB_FindXAssetHeader_t;
opd_s DB_LinkXAssetEntry_t = { 0x1B0AC0, TOC };
XAssetEntryPoolEntry*(*DB_LinkXAssetEntry)(XAssetEntry *newEntry, int allowOverride) = (XAssetEntryPoolEntry*(*)(XAssetEntry *, int))&DB_LinkXAssetEntry_t;
opd_s Dvar_FindVar_t = { 0x452AA0, TOC };
dvar_s*(*Dvar_FindVar)(const char *name) = (dvar_s*(*)(const char *))&Dvar_FindVar_t;
opd_s Scr_ExecThread_t = { 0x05C7670, TOC };
unsigned short(*Scr_ExecThread)(scriptInstance_t inst, int handle, int paramcount) = (unsigned short(*)(scriptInstance_t , int, int))&Scr_ExecThread_t;
opd_s Scr_FreeThread_t = { 0x5B5138, TOC };
void(*Scr_FreeThread)(unsigned short handle, scriptInstance_t inst) = (void(*)(unsigned short, scriptInstance_t))&Scr_FreeThread_t;

opd_s Scr_GetMethod_t = { 0x2B3F88, TOC };
popd32(*Scr_GetMethod)(const char **pName, int *type) = (popd32(*)(const char **, int *))&Scr_GetMethod_t;

opd_s Scr_GetFunction_t = { 0x2BC3E0, TOC };
popd32(*Scr_GetFunction)(const char **pName, int *type) = (popd32(*)(const char **, int *))&Scr_GetFunction_t;

opd_s Scr_GetChecksum_t = { 0x5A4248, TOC };
void(*Scr_GetChecksum)(scrChecksum_t *vmChecksum, scriptInstance_t inst) = (void(*)(scrChecksum_t *, scriptInstance_t ))&Scr_GetChecksum_t;

opd_s Scr_GetFunctionHandle_t = { 0x592E38, TOC };
int(*Scr_GetFunctionHandle)(scriptInstance_t inst, const char *scriptName, const char *functionName) = (int(*)(scriptInstance_t, const char *, const char *))&Scr_GetFunctionHandle_t;

opd_s Scr_GetNumParam_t = { 0x5B5088, TOC };
int(*Scr_GetNumParam)(int scriptInstance) = (int(*)(int))&Scr_GetNumParam_t;

opd_s Scr_GetString_t = { 0x5BBCC0, TOC };
char*(*Scr_GetString)(unsigned int index, scriptInstance_t scriptInstance) = (char*(*)(unsigned int, scriptInstance_t))&Scr_GetString_t;


void Patch_RSA_Checker()
{
    uint32_t PPC[] = { 0x60000000 };
	sys_dbg_write_process_memory(0x1818C0, &PPC[0], 4);
    sys_dbg_write_process_memory(0x1818C4, &PPC[0], 4);
    sys_dbg_write_process_memory(0x1818C8, &PPC[0], 4);
	sys_dbg_write_process_memory(0x1818CC, &PPC[0], 4);
	sys_dbg_write_process_memory(0x1818D0, &PPC[0], 4);
}

void RemoveCheatProtection()//can use some cheat protected dvars 
{
	uint32_t PPC[] = { 0x60000000, 0x3B200000 };
	sys_dbg_write_process_memory(0x0000000, &PPC[0], 4);//need update for Zombies 2022
}

