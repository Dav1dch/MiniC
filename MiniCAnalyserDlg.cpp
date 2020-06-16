
// MiniCAnalyserDlg.cpp: 实现文件
//
#include <iostream>
#include <string>
#include <fstream>
#include "pch.h"
#include "framework.h"
#include "MiniCAnalyser.h"
#include "MiniCAnalyserDlg.h"
#include "afxdialogex.h"
#include "utils.h"
#include "Cgen.h"
#include "Analyse.h"

using namespace std;

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// 用于应用程序“关于”菜单项的 CAboutDlg 对话框
extern FILE *code_mc;
extern FILE *yyin;
extern FILE *result;
FILE *code;
extern FILE *lexOut;
extern "C" int yywrap(void);
extern int yyparse(void);
extern node *programNode;
string temp;
int traceCode = 1;

class CAboutDlg : public CDialogEx
{
public:
// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum
	{
		IDD = IDD_ABOUTBOX
	};
#endif

protected:
	virtual void DoDataExchange(CDataExchange *pDX); // DDX/DDV 支持

	// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

void CAboutDlg::DoDataExchange(CDataExchange *pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()

// CMiniCAnalyserDlg 对话框

CMiniCAnalyserDlg::CMiniCAnalyserDlg(CWnd *pParent /*=nullptr*/)
	: CDialogEx(IDD_MiniCANALYSER_DIALOG, pParent), fileContent(_T("")), fileName(_T("")), fileName2(_T(""))
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CMiniCAnalyserDlg::DoDataExchange(CDataExchange *pDX)
{
	CDialogEx::DoDataExchange(pDX);

	DDX_Control(pDX, IDC_CONTENT, content);
	DDX_Text(pDX, IDC_CONTENT, fileContent);
	DDX_Control(pDX, IDC_FILE, name);
	DDX_Text(pDX, IDC_FILE, fileName);
	DDX_Control(pDX, IDC_CONTENT2, content2);
	DDX_Control(pDX, IDC_FILE2, treeFileName);
	//  DDX_Text(pDX, IDC_CONTENT2, fileContent2);
	DDX_Text(pDX, IDC_FILE2, fileName2);
}

BEGIN_MESSAGE_MAP(CMiniCAnalyserDlg, CDialogEx)
ON_WM_SYSCOMMAND()
ON_WM_PAINT()
ON_WM_QUERYDRAGICON()
ON_COMMAND(ID_32771, &CMiniCAnalyserDlg::Open)
ON_COMMAND(ID_32773, &CMiniCAnalyserDlg::CreateTree)
ON_COMMAND(ID_32774, &CMiniCAnalyserDlg::ShowTree)
ON_COMMAND(ID_32775, &CMiniCAnalyserDlg::Exit)
ON_EN_CHANGE(IDC_FILE, &CMiniCAnalyserDlg::OnEnChangeFile)
ON_EN_CHANGE(IDC_CONTENT2, &CMiniCAnalyserDlg::OnEnChangeContent2)
END_MESSAGE_MAP()

// CMiniCAnalyserDlg 消息处理程序

BOOL CMiniCAnalyserDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu *pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != nullptr)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。  当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);	 // 设置大图标
	SetIcon(m_hIcon, FALSE); // 设置小图标

	// TODO: 在此添加额外的初始化代码

	return TRUE; // 除非将焦点设置到控件，否则返回 TRUE
}

void CMiniCAnalyserDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。  对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CMiniCAnalyserDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CMiniCAnalyserDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

/*
	打开文件函数
	打开的位置是当前根目录同级的txt文件夹之下
*/
void CMiniCAnalyserDlg::Open()
{
	if (yyin != nullptr)
	{
		fclose(yyin);
	}
	CFileDialog opendlg(true, NULL, NULL,
						OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT,
						(LPCTSTR)_TEXT("TXT Files (*.txt)|*.txt|All Files (*.*)|*.*||"), NULL);
	if (opendlg.DoModal() == IDOK)
	{ //显示对话框并允许用户进行选择。

		CString filepathname = opendlg.GetPathName(); //文件路径
		name.SetWindowText(filepathname);
		CStdioFile fsend;
		CString s_one;
		CString fileContent;
		if (fsend.Open(filepathname, CFile::typeText | CFile::modeRead))
		{ //只读模式打开txt文件
			while (fsend.ReadString(s_one))
			{ //逐行读取文件内容
				fileContent += s_one;
				fileContent += "\r\n";
			}
			content.SetWindowTextW(fileContent); //将读取的文本显示在编辑框
			fsend.Close();
		}
		temp = CT2A(filepathname.GetString());
	}
	else
		return;
}

/*
	生成语法树函数
	生成的语法树以字符串的形式先加到fileContent2，注意换行符号 
	再将fileContent2写进文件里
*/
void CMiniCAnalyserDlg::CreateTree()
{

	//生成的语法树存放的文件位置以及文件名
	string treePath = "./txt/syntaxtree.txt";
	yyin = fopen(temp.c_str(), "r");
	result = fopen(treePath.c_str(), "w+");
	lexOut = fopen("./txt/lex.txt", "w+");
	programNode = newStmtNode(ProgramK);
	yyparse();	 // 生成语法树同时打印词法树
	printTree(); // 打印语法树
	yywrap();
	fclose(result);
	fclose(lexOut);
	fclose(yyin);


	//code_mc = fopen("./txt/lex.txt", "w+");
	code = fopen("code.mc", "w+");
	// 	生成字符表
	buildSymtab(programNode->nodeChild[0]->next);


	// 生成中间代码
	codeGen(programNode->nodeChild[0]->next);
	fclose(code);

	MessageBox(L"生成成功，点击查看即可查看语法树");
}

/*
	查看语法树函数
	对指定的文件进行查看
*/
void CMiniCAnalyserDlg::ShowTree()
{
	UpdateData(TRUE);
	string treePath = "./txt/syntaxtree.txt";
	CString t = L"./txt/syntaxtree.txt";

	CStdioFile fsend;
	CString s_one;
	CString fileContent;
	if (fsend.Open(t, CFile::typeText | CFile::modeRead))
	{ //只读模式打开txt文件
		while (fsend.ReadString(s_one))
		{ //逐行读取文件内容
			fileContent += s_one;
			fileContent += "\r\n";
		}
		content2.SetWindowTextW(fileContent); //将读取的文本显示在编辑框
		fsend.Close();
	}

}

/*
退出函数
*/
void CMiniCAnalyserDlg::Exit()
{
	OnCancel();
}

void CMiniCAnalyserDlg::OnEnChangeFile()
{
	// TODO:  如果该控件是 RICHEDIT 控件，它将不
	// 发送此通知，除非重写 CDialogEx::OnInitDialog()
	// 函数并调用 CRichEditCtrl().SetEventMask()，
	// 同时将 ENM_CHANGE 标志“或”运算到掩码中。

	// TODO:  在此添加控件通知处理程序代码
}

void CMiniCAnalyserDlg::OnEnChangeContent2()
{
	// TODO:  如果该控件是 RICHEDIT 控件，它将不
	// 发送此通知，除非重写 CDialogEx::OnInitDialog()
	// 函数并调用 CRichEditCtrl().SetEventMask()，
	// 同时将 ENM_CHANGE 标志“或”运算到掩码中。

	// TODO:  在此添加控件通知处理程序代码
}
