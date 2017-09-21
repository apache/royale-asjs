/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
// ContinueAfterRuntimeException.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "resource.h"

#define MAX_LOADSTRING 100

// Global Variables:
HINSTANCE hInst;								// current instance
TCHAR szTitle[MAX_LOADSTRING];								// The title bar text
TCHAR szWindowClass[MAX_LOADSTRING];								// The title bar text
TCHAR szPlayer[] = "Adobe Flash Player 9";
TCHAR szPlayer10[] = "Adobe Flash Player 10";

UINT timer;

// Foward declarations of functions included in this code module:
ATOM				MyRegisterClass(HINSTANCE hInstance);
BOOL				InitInstance(HINSTANCE, int);
LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);
LRESULT CALLBACK	About(HWND, UINT, WPARAM, LPARAM);

WSADATA wsaData;

hostent* localHost;
char* localIP;
struct sockaddr_in sockaddr;
SOCKADDR connaddr;
int addrlen = sizeof(connaddr);

int iResult;
SOCKET ConnectSocket = INVALID_SOCKET;
SOCKET ListenSocket = INVALID_SOCKET;


int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow)
{
 	// TODO: Place code here.
	MSG msg;
	HACCEL hAccelTable;

	// Initialize global strings
	LoadString(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadString(hInstance, IDC_CONTINUEAFTERRUNTIMEEXCEPTION, szWindowClass, MAX_LOADSTRING);
	MyRegisterClass(hInstance);

	// Initialize Winsock
	iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
	if (iResult != 0) {
		return 1;
	}

	// Perform application initialization:
	if (!InitInstance (hInstance, nCmdShow)) 
	{
		return FALSE;
	}

	hAccelTable = LoadAccelerators(hInstance, (LPCTSTR)IDC_CONTINUEAFTERRUNTIMEEXCEPTION);

	// Main message loop:
	while (GetMessage(&msg, NULL, 0, 0)) 
	{
		if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg)) 
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}

	// shutdown the connection since no more data will be sent
	iResult = shutdown(ListenSocket, SD_BOTH);
	closesocket(ListenSocket);
	ListenSocket = INVALID_SOCKET;

	WSACleanup();
	return msg.wParam;
}



//
//  FUNCTION: MyRegisterClass()
//
//  PURPOSE: Registers the window class.
//
//  COMMENTS:
//
//    This function and its usage is only necessary if you want this code
//    to be compatible with Win32 systems prior to the 'RegisterClassEx'
//    function that was added to Windows 95. It is important to call this function
//    so that the application will get 'well formed' small icons associated
//    with it.
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX); 

	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= (WNDPROC)WndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= 0;
	wcex.hInstance		= hInstance;
	wcex.hIcon			= LoadIcon(hInstance, (LPCTSTR)IDI_CONTINUEAFTERRUNTIMEEXCEPTION);
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground	= (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName	= (LPCSTR)IDC_CONTINUEAFTERRUNTIMEEXCEPTION;
	wcex.lpszClassName	= szWindowClass;
	wcex.hIconSm		= LoadIcon(wcex.hInstance, (LPCTSTR)IDI_SMALL);

	return RegisterClassEx(&wcex);
}

//
//   FUNCTION: InitInstance(HANDLE, int)
//
//   PURPOSE: Saves instance handle and creates main window
//
//   COMMENTS:
//
//        In this function, we save the instance handle in a global variable and
//        create and display the main program window.
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
   HWND hWnd;

   hInst = hInstance; // Store instance handle in our global variable

   hWnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, NULL, NULL, hInstance, NULL);

   if (!hWnd)
   {
      return FALSE;
   }

   timer = SetTimer(hWnd, 1, 1000, NULL);

	localHost = gethostbyname("");
	localIP = "127.0.0.1"; //inet_ntoa (*(struct in_addr *)*localHost->h_addr_list);

#ifdef _DEBUG
	OutputDebugString("Listening on socket ");
	OutputDebugString(localIP);
	OutputDebugString("\n");
#endif

	ShowWindow(hWnd, nCmdShow);
    UpdateWindow(hWnd);


	ZeroMemory( &sockaddr, sizeof(sockaddr) );
	// Set up the sockaddr structure
	sockaddr.sin_family = AF_INET;
	sockaddr.sin_addr.s_addr = inet_addr(localIP);
	sockaddr.sin_port = htons(2561);

	// Create a SOCKET for connecting to server
	ListenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_IP); 
	if (ListenSocket == INVALID_SOCKET) 
	{
		return FALSE;
	}
	iResult = bind(ListenSocket, (SOCKADDR *)&sockaddr, sizeof(sockaddr));
	if (iResult == SOCKET_ERROR) 
	{
		closesocket(ListenSocket);
		ListenSocket = INVALID_SOCKET;
		return FALSE;
	}
	iResult = listen(ListenSocket, 1);
	if (iResult == SOCKET_ERROR) 
	{
		closesocket(ListenSocket);
		ListenSocket = INVALID_SOCKET;
		return FALSE;
	}

   WSAAsyncSelect(ListenSocket, hWnd, EM_SETSEL, FD_CLOSE);

   return TRUE;
}

void CheckForExceptionDialog(HWND hWnd)
{
	hWnd = GetWindow(hWnd, GW_HWNDFIRST);
	while (hWnd)
	{
		char szTitle[1024];
		GetWindowText(hWnd, szTitle, 256);
		if (lstrcmp(szTitle, szPlayer) == 0 || lstrcmp(szTitle, szPlayer10) == 0)
		{
			HWND hDlg = hWnd; 
			HWND hChild = GetWindow(hWnd, GW_CHILD);
			char szError[1024];
			szError[0] = '\0';
			HWND hButton = (HWND)INVALID_HANDLE_VALUE;
			LONG idButton = 0;
			while (hChild)
			{
				GetWindowText(hChild, szTitle, 1024);
				if (lstrcmp(szTitle, "&Continue") == 0)
				{
					idButton = GetWindowLong(hChild, GWL_ID);
					hButton = hChild;
				}
				else 
				{
					char szClassName[256];
					GetClassName(hChild, szClassName, 256);
					if (lstrcmp(szClassName, "Edit") == 0)
					{
						SendMessage(hChild, WM_GETTEXT, MAKELONG(LOWORD(1024), 0), (LONG)szError);
					}
				}
				hChild = GetWindow(hChild, GW_HWNDNEXT);
			}
			if (hButton != INVALID_HANDLE_VALUE)
			{
				if (ConnectSocket != INVALID_SOCKET)
				{
					// Send an initial buffer
					iResult = send( ConnectSocket, szError, (int)strlen(szError), 0 );
					if (iResult == SOCKET_ERROR) 
					{
#ifdef _DEBUG
						OutputDebugString("Error sending to socket\n");
#endif
						closesocket(ConnectSocket);
						ConnectSocket = INVALID_SOCKET;
						return;
					}
#ifdef _DEBUG
					else
						OutputDebugString(szError);
#endif

				}

				SendMessage(hDlg, WM_COMMAND, MAKELONG(LOWORD(idButton), BN_CLICKED), (LONG)hButton);

				return;
			}
		}
		hWnd = GetWindow(hWnd, GW_HWNDNEXT);
	}
}

//
//  FUNCTION: WndProc(HWND, unsigned, WORD, LONG)
//
//  PURPOSE:  Processes messages for the main window.
//
//  WM_COMMAND	- process the application menu
//  WM_PAINT	- Paint the main window
//  WM_DESTROY	- post a quit message and return
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	int wmId, wmEvent;
	PAINTSTRUCT ps;
	HDC hdc;
	TCHAR szHello[MAX_LOADSTRING];
	LoadString(hInst, IDS_HELLO, szHello, MAX_LOADSTRING);

	switch (message) 
	{
		case WM_COMMAND:
			wmId    = LOWORD(wParam); 
			wmEvent = HIWORD(wParam); 
			// Parse the menu selections:
			switch (wmId)
			{
				case IDM_ABOUT:
				   DialogBox(hInst, (LPCTSTR)IDD_ABOUTBOX, hWnd, (DLGPROC)About);
				   break;
				case IDM_EXIT:
				   DestroyWindow(hWnd);
				   break;
				default:
				   return DefWindowProc(hWnd, message, wParam, lParam);
			}
			break;
		case WM_PAINT:
			hdc = BeginPaint(hWnd, &ps);
			// TODO: Add any drawing code here...
			RECT rt;
			GetClientRect(hWnd, &rt);
			if (localIP)
				DrawText(hdc, localIP, strlen(localIP), &rt, DT_CENTER);
			EndPaint(hWnd, &ps);
			break;
		case WM_TIMER:
			if (ConnectSocket == INVALID_SOCKET)
			{
				ConnectSocket = accept(ListenSocket, &connaddr, &addrlen);
				if (ConnectSocket != INVALID_SOCKET)
				{
#ifdef _DEBUG
						OutputDebugString("Connected to socket\n");
#endif
				}
			}
			CheckForExceptionDialog(hWnd);
			break;
		case WM_DESTROY:
			PostQuitMessage(0);
			break;
		case EM_SETSEL:
			ConnectSocket = INVALID_SOCKET;
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
   }
   return 0;
}

// Mesage handler for about box.
LRESULT CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		case WM_INITDIALOG:
				return TRUE;

		case WM_COMMAND:
			if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL) 
			{
				EndDialog(hDlg, LOWORD(wParam));
				return TRUE;
			}
			break;
	}
    return FALSE;
}

