#include "Type.h"
#include <sstream>

IntType TypeSystem::commonInt = IntType(4);
VoidType TypeSystem::commonVoid = VoidType();

Type* TypeSystem::intType = &commonInt;
Type* TypeSystem::voidType = &commonVoid;

std::string IntType::toStr()
{
    return "int";
}

bool IntType::is_const()
{
    return isconst;
}

std::string VoidType::toStr()
{
    return "void";
}

bool VoidType::is_const()
{
    return false;
}

std::string FunctionType::toStr()
{
    std::ostringstream buffer;
    buffer << returnType->toStr() << "()";
    return buffer.str();
}

bool FunctionType::is_const()
{
    return false;
}

