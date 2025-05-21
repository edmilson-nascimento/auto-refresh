# auto-refresh

[![ABAP](https://img.shields.io/badge/ABAP-0061AF?style=flat&logo=sap&logoColor=white)](https://help.sap.com/doc/abapdocu_latest_index_htm/latest/en-US/index.htm)
[![SAP](https://img.shields.io/badge/SAP-0FAAFF?style=flat&logo=sap&logoColor=white)](https://www.sap.com/)
[![ABAP OO](https://img.shields.io/badge/ABAP_OO-2B447D?style=flat&logo=sap&logoColor=white)](https://help.sap.com/doc/abapdocu_latest_index_htm/latest/en-US/index.htm)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/edmilson-nascimento/auto-refresh)
[![SAP Development](https://img.shields.io/badge/SAP_Development-00BCE4?style=flat&logo=sap&logoColor=white)](https://community.sap.com/topics/abap)
[![SAP On-Premise](https://img.shields.io/badge/SAP_On--Premise-4A90E2?style=flat&logo=sap&logoColor=white)](https://www.sap.com/)
[![GitHub issues](https://img.shields.io/github/issues/edmilson-nascimento/auto-refresh?style=flat)](https://github.com/edmilson-nascimento/auto-refresh/issues)
[![GitHub commit](https://img.shields.io/github/last-commit/edmilson-nascimento/auto-refresh?style=flat)](https://github.com/edmilson-nascimento/auto-refresh/commits/main)

## Overview

This ABAP program demonstrates how to implement an auto-refreshing ALV (ABAP List Viewer) report using timer functionality. The program updates displayed data at regular intervals without manual intervention.

## Technical Details

The program uses Object-Oriented ABAP and consists of these main components:

- **Timer Control**: Uses `CL_GUI_TIMER` for automatic refresh at 3-second intervals
- **Data Display**: Implements `CL_SALV_TABLE` for modern ALV output
- **Event Handling**: Uses events to manage refresh cycles

## Key Methods

- `HANDLE_FINISHED`: Triggered when timer completes, updates counter and refreshes data
- `SHOW_DATA`: Manages ALV display initialization and configuration
- `GET_DATA`: Retrieves current system data (username and timestamp) and refreshes display

## Use Cases

This example is particularly useful for:
- Real-time monitoring applications
- Dashboard displays requiring frequent updates
- System status monitoring
- User activity tracking

## Implementation Benefits

- Automated refresh without user intervention
- Clean Object-Oriented design
- Minimal system resource usage
- Modern ALV implementation with SALV

## How to Use

1. The program initializes with a 3-second refresh interval
2. Data updates automatically show username and timestamp
3. ALV refreshes without flickering or screen rebuilding
4. No manual refresh required

This pattern can be adapted for various monitoring scenarios where real-time data display is needed.
