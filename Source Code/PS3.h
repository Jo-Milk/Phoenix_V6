bool DEX = true;//would be cool to find a way to detect if hen or dex that doesn't take too much space in memory
bool hen = false;

int32_t sys_dbg_write_process_memory_hen(uint64_t ea, const void* data, size_t size)
{
    system_call_6(8, 0x7777, 0x32, (uint64_t)sys_process_getpid(), (uint64_t)ea, (uint64_t)data, (uint64_t)size);
}
int32_t sys_dbg_write_process_memory_Dex(uint64_t ea, const void* data, size_t size)
{
    system_call_4(905, (uint64_t)sys_process_getpid(), ea, size, (uint64_t)data);
    return_to_user_prog(int32_t);
}
int32_t sys_dbg_write_process_memory(uint64_t ea, const void* data, size_t size)
{
	if(hen == true)
	{
    sys_dbg_write_process_memory_hen(ea, data,  size);
	}
	else
	{
	sys_dbg_write_process_memory_Dex(ea, data,  size);
	}
}
int32_t sys_dbg_read_process_memory_hen(uint64_t ea, const void* data, size_t size)
{
     system_call_6(8, 0x7777, 0x31, (uint64_t)sys_process_getpid(), (uint64_t)ea, (uint64_t)data, (uint64_t)size);
}
int32_t sys_dbg_read_process_memory_Dex(uint64_t ea, const void* data, size_t size)
{
     system_call_4(904, (uint64_t)sys_process_getpid(), ea, size, (uint64_t)data);
     return_to_user_prog(int32_t);
}
int32_t sys_dbg_read_process_memory(uint64_t ea, void* data, size_t size)
{
	if(hen == true)
	{
        sys_dbg_read_process_memory_hen(ea, data,  size);
	}
	else
	{
	    sys_dbg_read_process_memory_Dex(ea, data,  size);
	}
}

template<typename T>
void WriteProcessMemory(uint32_t address, const T value, size_t size)
{
	sys_dbg_write_process_memory(address, &value, size);
}

void HookFunctionStart(uint32_t functionStartAddress, uint32_t newFunction, uint32_t functionStub)
{
    uint32_t normalFunctionStub[8], hookFunctionStub[4];
    sys_dbg_read_process_memory(functionStartAddress, normalFunctionStub, 0x10);
    normalFunctionStub[4] = 0x3D600000 + ((functionStartAddress + 0x10 >> 16) & 0xFFFF);
    normalFunctionStub[5] = 0x616B0000 + (functionStartAddress + 0x10 & 0xFFFF);
    normalFunctionStub[6] = 0x7D6903A6;
    normalFunctionStub[7] = 0x4E800420;
    sys_dbg_write_process_memory(functionStub, normalFunctionStub, 0x20);
    hookFunctionStub[0] = 0x3D600000 + ((newFunction >> 16) & 0xFFFF);
    hookFunctionStub[1] = 0x616B0000 + (newFunction & 0xFFFF);
    hookFunctionStub[2] = 0x7D6903A6;
    hookFunctionStub[3] = 0x4E800420;
    sys_dbg_write_process_memory(functionStartAddress, hookFunctionStub, 0x10);
}
int32_t HookFunction(uint32_t address, uint32_t function)
{
	uint32_t opcode[4];
	opcode[0] = 0x3D600000 + ((function >> 16) & 0xFFFF);
	opcode[1] = 0x616B0000 + (function & 0xFFFF);
	opcode[2] = 0x7D6903A6;
	opcode[3] = 0x4E800420;
	return sys_dbg_write_process_memory(address, &opcode, 0x10);
}
int32_t BranchLinkedHook(uint32_t branchFrom, uint32_t branchTo)
{
    uint32_t branch;
    if (branchTo > branchFrom)
        branch = 0x48000001 + (branchTo - branchFrom);
    else
        branch = 0x4C000001 - (branchFrom - branchTo);
    return sys_dbg_write_process_memory(branchFrom, &branch, 4);
}
size_t get_file_size(char *filePath)
{
    int size = 0;
    CellFsStat fstat;
    CellFsErrno err = cellFsStat(filePath, &fstat);
    if (err != CELL_FS_SUCCEEDED)
    {
        return err;
    }
    return fstat.st_size;
}

int console_write(const char * s)
{
        uint32_t len;
        system_call_4(403, 0, (uint64_t) s, 32, (uint64_t) &len);
        return_to_user_prog(int);
}
void sleep(usecond_t time)
{
        sys_timer_usleep(time * 1000);
}

int sys_ppu_thread_exit()//I think this for the debugger
{
	system_call_1(41, 0);//using syscall 41 int sys_ppu_thread_exit(error code)
	return_to_user_prog(int);
}

bool yesno_dialog_result = false;
bool yesno_dialog_input = false;
bool ok_dialog_input = false;
bool ok_dialog_result = false;

void YesNoDialogCallBack(int button_type, void *userdata)
{
	switch (button_type)
	{
	case CELL_MSGDIALOG_BUTTON_YES:
		yesno_dialog_result = true;
		break;
	case CELL_MSGDIALOG_BUTTON_NO:
		yesno_dialog_result = false;
		break;
	}
	yesno_dialog_input = false;
}

bool DrawYesNoMessageDialog(const char *str)
{
	cellMsgDialogOpen2(CELL_MSGDIALOG_TYPE_SE_TYPE_NORMAL | CELL_MSGDIALOG_TYPE_BUTTON_TYPE_YESNO | CELL_MSGDIALOG_TYPE_DISABLE_CANCEL_ON | CELL_MSGDIALOG_TYPE_DEFAULT_CURSOR_NO, str, YesNoDialogCallBack, NULL, NULL);
	yesno_dialog_input = true;
	while (yesno_dialog_input)
	{
		sleep(16);
		cellSysutilCheckCallback();
	}
	return yesno_dialog_result;
}

void OkDialogCallBack(int button_type, void *userdata)
{
	switch (button_type)
	{
	case CELL_MSGDIALOG_BUTTON_OK:ok_dialog_result = true;break;
	default : break;
	}
	ok_dialog_input = false;
}
void DrawOkMessageDialog(const char *str)
{
	cellMsgDialogOpen2(CELL_MSGDIALOG_TYPE_SE_TYPE_NORMAL | CELL_MSGDIALOG_TYPE_BUTTON_TYPE_OK | CELL_MSGDIALOG_TYPE_DISABLE_CANCEL_ON | CELL_MSGDIALOG_TYPE_DEFAULT_CURSOR_OK, str, OkDialogCallBack, NULL, NULL);
	ok_dialog_input = true;
	while (ok_dialog_input)
	{
		sleep(16);
		cellSysutilCheckCallback();
	}
}
const char * GetSelfUserName()
{
    CellUserInfoUserStat stat;
    cellUserInfoGetStat(CELL_SYSUTIL_USERID_CURRENT, &stat);
    return stat.name;
}
 
const char * GetSelfOnlineName()
{
    SceNpOnlineName onlineName;
    sceNpManagerGetOnlineName(&onlineName);
    return onlineName.data;
}
 
const char * GetSelfName()
{
    int connectionStatus;
    sceNpManagerGetStatus(&connectionStatus);//checks if online
    if (connectionStatus == SCE_NP_MANAGER_STATUS_ONLINE)
        return GetSelfOnlineName();
    else
        return GetSelfUserName();
}



