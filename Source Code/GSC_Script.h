void scrfct_setmemory()
{
    // Verify that we have 2 parameters for this function.
    if (Scr_GetNumParam(0) == 2)
    {
        // Getting parameters, we don't check the type using a function again here but we could have did it.
        char *hexAddress = Scr_GetString(0, SCRIPTINSTANCE_SERVER);
        char *hexData = Scr_GetString(1, SCRIPTINSTANCE_SERVER);

        if (hexAddress && hexData)
        {
            // Allocate input size +2 in case to handle zero padding and null terminated char.
            char hexAddressFixed[strlen(hexAddress) + 2];
            char hexDataFixed[strlen(hexData) + 2];
               
            hex_str_to_padded_hex_str(hexAddressFixed, hexAddress);
            hex_str_to_padded_hex_str(hexDataFixed, hexData);

            size_t addressSize = strlen(hexAddressFixed)/2;
            size_t dataSize = strlen(hexDataFixed)/2;

            int offset = hex_str_to_int32(hexAddressFixed, addressSize);

            char buffer[dataSize];
            memset(buffer, 0, dataSize);
            hex_str_to_buffer(buffer, hexDataFixed, dataSize);

            sys_dbg_write_process_memory(offset, buffer, dataSize);

            printf("Function 'setMemory' called from gsc with the following parameters: %s, %s.\n", hexAddress, hexData);
        }
        else
            printf("Cannot resolve setmemory parameters call from gsc.");
    }
}