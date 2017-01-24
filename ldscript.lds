SECTIONS
{
  dynamicInit : {
    __start_dynamicInit = .;
    *(dynamicInit)
    __stop_dynamicInit = .;
  }
}
INSERT AFTER .text;