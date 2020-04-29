/*
 * @Copyright: minic 
 * @Author: David.Huangjunlang 
 * @File: scan.h 
 * @Descriptions: 定义在词法分析过程中所需要的变量
 * @Last Modified by: David.Huangjunlang
 * @Last Modified time: 2020-04-22 15:30:52
 */

#ifndef SCAN_H
#define SCAN_H

typedef enum
{
    /* book-keeping tokens */
    END_OF_FILE, // eof
    UNEXPECTED,  // 不存在的字符
    /* multicharacter tokens */
    ID,          // identifier
    NUM,         // number
    /* reserved words */
    ELSE,
    IF,
    INT,
    RETURN,
    VOID,
    WHILE,
    /* special symbols */
    PLUS,
    MINUS,
    MULTI,
    DIVIDE,
    LESS,
    LESSEQUAL,
    GREATER,
    GREATEREQUAL,
    EQUAL,
    UNEQUAL,
    ASSIGNMENT,
    SEMICOLON,
    COMMA,
    LEFTBRACKET,
    RIGHTBRACKET,
    LEFTSQUAREBRACKET,
    RIGHTSQUAREBRACKET,
    LEFTBRACE,
    RIGHTBRACE,
    LEFTCOMMENT,
    RIGHTCOMMENT
} Token;

#endif
