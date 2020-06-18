
// MiniCAnalyserDlg.h: 头文件
//

#pragma once


// CMiniCAnalyserDlg 对话框
class CMiniCAnalyserDlg : public CDialogEx
{
// 构造
public:
	CMiniCAnalyserDlg(CWnd* pParent = nullptr);	// 标准构造函数

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_MiniCANALYSER_DIALOG };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持


// 实现
protected:
	HICON m_hIcon;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void Open();
	afx_msg void Save();
	afx_msg void CreateTree();
	afx_msg void ShowTree();
	afx_msg void OnEnChangeEdit1();
//	CString fileText;
//	CEdit fileEdit;
//	CEdit file;
//	CEdit content;
	CEdit content;
	CString fileContent;
	CEdit name;
	CString fileName;
	afx_msg void Exit();
	afx_msg void OnEnChangeFile();
	afx_msg void OnEnChangeContent2();
	CEdit content2;
	CEdit treeFileName;
//	CString fileContent2;
	CString fileName2;
	afx_msg void On32776();
	afx_msg void On32777();
};
