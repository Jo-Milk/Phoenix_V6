#define TOC	0x00A544B0

#include "printf.h"
#include <np.h>

#include <sys/prx.h>
#include <sys/socket.h>
#include <sysutil/sysutil_userinfo.h>
#include <stdarg.h>
#include <limits.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <stdint.h>
#include <math.h>

#include <sys/process.h>
#include <sys/ppu_thread.h>
#include <sys/syscall.h>

#include <sysutil/sysutil_msgdialog.h>
#include <sysutil/sysutil_oskdialog.h>
#include <sysutil/sysutil_userinfo.h>

#include <cell/fs/cell_fs_file_api.h>
#include <cell/spurs/lfqueue.h>
#include <cell/error.h>
#include <sys/memory.h>
#include <sys/timer.h>

#include "Variables.h"
#include "Hook_Stub.h"
#include "PS3.h"
#include "Offset.h"
#include "Functions.h"
#include "GSC_Script.h"
#include "Hooks.h"



SYS_MODULE_INFO( RPCS3, 0, 1, 1);
SYS_MODULE_START( _RPCS3_prx_entry );

SYS_LIB_DECLARE_WITH_STUB( LIBNAME, SYS_LIB_AUTO_EXPORT, STUBNAME );
SYS_LIB_EXPORT( _RPCS3_export_function, LIBNAME );

// An exported function is needed to generate the project's PRX stub export library
extern "C" int _RPCS3_export_function(void)
{
    return CELL_OK;
}

void cs_hook_resolve_import_opd(popd32 source,popd32 detour,popd32 *tramp)
{
    int opd_import0 = *(int*)(((int)source) + 4);
    int  opd_import1 = *(int*)(((int)source) + 8);
    opd32 *import_opd = *(opd32**)(opd_import0 << 16 | opd_import1 & 0xFFFF);
	opd32 trampoline_opd;
    trampoline_opd.function = import_opd->function;
    trampoline_opd.toc = import_opd->toc;
	*tramp = &trampoline_opd;
	int op[2];
        op[0] = 0x658C0000 + (((int)&detour >> 16) & 0xFFFF);
        op[1] = 0x818C0000 + ((int)&detour & 0xFFFF);
    sys_dbg_write_process_memory((uintptr_t)source->function + 4, &op, 8);
}
int init_hooks()
{
	HookFunctionStart(T5_Scr_GetChecksum_ZM, *(uint32_t*)Scr_GetChecksum_Hook, *(uint32_t*)Scr_GetChecksum_Trampoline);//Allows GSC to run with OFW by replacing checksum with valid one
	HookFunctionStart(T5_Scr_LoadGameType_ZM, *(uint32_t*)Scr_LoadGameType_Hook, *(uint32_t*)Scr_LoadGameType_Trampoline);//gets the main handle
	HookFunctionStart(T5_Scr_LoadScript_ZM, *(uint32_t*)Scr_LoadScript_Hook, *(uint32_t*)Scr_LoadScript_Trampoline);//Executes the gsc function main and replaces checksum taken by Scr_GetChecksum_Hook
	HookFunctionStart(T5_Scr_GetFunction_ZM, *(uint32_t*)Scr_GetFunction_Hook, *(uint32_t*)Scr_GetFunction_Trampoline);//Hooks into Scr_GetFunction to redirect gsc function to the SPRX
	HookFunctionStart(T5_cellSpursLFQueuePushBody_ZM, *(uint32_t*)cellSpursLFQueuePushBody_Hook, *(uint32_t*)cellSpursLFQueuePushBody_Trampoline);// READS GSC FILES and injects
    return 0;
}

int init_game()
{
    // Current process is Black Ops ZM?
    if (*(int*)(0x1002C) == 0xA56728)//ZM offset
       {
		// Init offsets / hooks ZM
		int err;
        if ((err = init_hooks()) < 0)
        {
        //console_write("Hooks install failed.");
        return -2;
        }
        return 0;
	}
    else
    {
        //not Black Ops 1.13 Zombies");
        return -1;
    }
}


void launcher(uint64_t)
{
	sys_prx_get_module_list_t pInfo;
    pInfo.max = 25;
    sys_prx_id_t ids[pInfo.max];
    pInfo.idlist = ids;
    pInfo.size = sizeof(pInfo);
    while (pInfo.count < 20)
    {
        sys_prx_get_module_list(0, &pInfo);//looks number of PPU threads before starting the execution of the PRX
        sys_timer_sleep(10);
    }
	sleep(10000);
    if (init_game() == 0)
    {
        printf("GSC Loader ready.\n");
    }
	else
		printf("OUPSI error 1515\n");//debugging purposes

    sys_ppu_thread_exit(0);
}

sys_ppu_thread_t id;
extern "C" int _RPCS3_prx_entry(void)
{
	//Hen_or_Dex();
	//Patch_RSA_Checker(); For Hen purposes I will just make a custom Eboot
	//RemoveCheatProtection();// I need to find it for zombies because I forgot how I used to do it
	sys_ppu_thread_create(&id, launcher, 0, 100, 0x64, 0, "Jo-Milk");
    return SYS_PRX_RESIDENT;
}

/*
RSA Checker bytes //ZM //0x1818C0
This : 2C 8E 00 00 40 86 FE F0 82 C1 00 80 2F 16 00 01 40 9A FE E4
With this : 60 00 00 00 60 00 00 00 60 00 00 00 60 00 00 00 60 00 00 00
*/


//need change string for ZM instead MP