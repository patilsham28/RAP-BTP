# SAP RAP Sales Order Management Application

> A transactional Sales Order management application built with SAP ABAP RAP, CDS, OData, and Fiori Elements.

## 📌 Project Overview

This project demonstrates a complete Sales Order business object using the ABAP RESTful Application Programming Model (RAP).

The application manages Sales Order Header and Item data with a parent-child composition. It includes CDS-based data modeling, managed RAP behavior, early numbering, validation, determinations for price calculation, a custom action to copy items, UI annotations, service definition, and service binding.

The repository contains the SAP development objects exported with abapGit.

## 🏗️ Solution Architecture

```text
SAP HANA Tables
     │
     ▼
Interface CDS Views
     │
     ▼
RAP Behavior Definition
     │
     ├── Early Numbering
     ├── Validation
     ├── Determinations
     └── Custom Action
     │
     ▼
Projection CDS Views
     │
     ▼
Service Definition
     │
     ▼
Service Binding / OData
     │
     ▼
Fiori Elements Application
```

## 🧩 Business Object

The project uses a Sales Order Header–Item structure.

### Header

Database table: `Y185M_SO_HEADER`

| Field | Description |
|---|---|
| `SOID` | Sales Order ID |
| `ORDER_DATE` | Order Date |
| `CUSTOMER` | Customer |
| `CURRENCY` | Currency |
| `CREATD_BY` | Created By |
| `TOTAL_AMOUNT` | Calculated Header Total |
| `STATUS` | Order Status |

### Item

Database table: `Y185M_SO_ITEM`

| Field | Description |
|---|---|
| `SO_ID` | Parent Sales Order ID |
| `ITEM_ID` | Item ID |
| `MATERIAL` | Material |
| `QUANTITY` | Quantity |
| `NET_PRICE` | Net Price |
| `TOTAL_PRICE` | Calculated Item Total |

## 🔹 CDS Data Model

The core interface views are:

- `Y185_I_SO_HEADER01`
- `Y185_I_SO_ITEM`

The Header CDS view is a root view entity and defines a composition to the Item entity. The Item CDS view uses an association to the parent Header entity.

```text
Y185_I_SO_HEADER01
        │
        │ Composition [0..*]
        ▼
Y185_I_SO_ITEM
```

The Header interface view also derives readable status text and status criticality from the stored status value.

## ⚙️ RAP Behavior

The Header behavior definition uses a managed RAP implementation:

`zbp_185_i_so_header01`

### Header Operations

- Create
- Update
- Delete
- Early numbering
- Customer validation
- Create-by-association for Items

### Item Operations

- Update
- Delete
- Early numbering
- Total Price determination
- Header Total determination
- `copyItem` factory action

## 🔢 Early Numbering

The project implements early numbering for both Sales Orders and Sales Order Items.

### Sales Order ID

New Sales Orders are assigned IDs in the format:

```text
SO000001
SO000002
SO000003
...
```

The implementation reads the highest existing Sales Order number and generates the next identifier.

### Item ID

Item IDs are generated separately for each Sales Order and formatted as a 10-digit value.

```text
0000000001
0000000002
0000000003
...
```

## ✅ Validation

A RAP validation named `Validatecustomer` runs during save processing. It ensures that the Customer field is not empty.

When validation fails:

```text
Customer cannot be empty
```

is returned as an error message and the invalid Header instance is marked as failed.

## 🧮 Determinations

The Item behavior contains two determinations.

### Calculate Item Total

`calculateTotalPrice`

The total price is calculated as:

```text
Total Price = Quantity × Net Price
```

Whenever Quantity or Net Price changes, the Item Total Price is recalculated.

### Calculate Header Total

`calculateHeaderTotal`

The determination reads the Item totals for the affected Sales Order and calculates:

```text
Header Total Amount = Sum of Item Total Prices
```

The calculated amount is then written back to the Sales Order Header.

## 📋 Custom Action — Copy Item

The Item entity provides a custom factory action:

`copyItem`

The action reads the selected Item and creates a new Item under the same Sales Order using Create-by-Association.

The copied Item retains:

- Material
- Quantity
- Net Price

A new Item ID is generated through the RAP numbering logic.

## 🖼️ Projection Layer

The consumption views are:

- `Y185C_SO_HEADER`
- `Y185C_SO_ITEM`

The projection layer exposes the transactional business object for service consumption.

The Item projection also contains UI annotations for fields, identification sections, and the Copy Item action.

## 🎨 Fiori Elements UI

The projection views contain UI annotations for the application presentation.

The Item projection defines:

- List Report fields
- Object Page identification fields
- Item Details facet
- Copy Item action
- Currency value help
- Header/Item navigation

The Header and Item entities are exposed together as a business service.

## 🌐 Service Exposure

### Service Definition

`Y185SD_HEADER`

Exposes:

```text
Y185C_SO_HEADER → Header
Y185C_SO_ITEM   → Item
```

### Service Binding

`Y185SB_HEADER`

The repository contains the service binding object used to expose the service for OData consumption.

## 🛠️ Technologies Used

| Technology | Usage |
|---|---|
| SAP ABAP | Application logic |
| ABAP RAP | Transactional business object |
| CDS Views | Data modeling |
| SAP HANA | Persistence |
| SAP S/4HANA | ABAP runtime/business platform |
| SAP BTP | Development environment |
| OData | Service exposure |
| Fiori Elements | UI consumption |
| abapGit | Source-code transport/versioning |

## 📂 Repository Structure

The SAP development objects are stored under the `src/` directory through abapGit.

```text
RAP-BTP/
│
├── src/
│   ├── Y185M_SO_HEADER
│   ├── Y185M_SO_ITEM
│   ├── Y185_I_SO_HEADER01
│   ├── Y185_I_SO_ITEM
│   ├── Y185C_SO_HEADER
│   ├── Y185C_SO_ITEM
│   ├── Behavior Definitions
│   ├── Behavior Implementation Classes
│   ├── Service Definition
│   ├── Service Binding
│   └── Supporting DDIC Objects
│
├── .abapgit.xml
└── README.md
```

## 🔄 Application Flow

```text
Create Sales Order
        ↓
Early Numbering → SO000001
        ↓
Enter Customer / Header Data
        ↓
Validate Customer
        ↓
Add Sales Order Items
        ↓
Early Numbering → Item ID
        ↓
Quantity × Net Price
        ↓
Calculate Item Total
        ↓
Calculate Header Total
        ↓
Save Sales Order
        ↓
Consume through OData / Fiori Elements
```


## 🎯 Key Learning Outcomes

This project provided hands-on experience with:

- RAP Managed Scenario
- Root and child entities
- Composition and parent-child associations
- CDS Interface and Projection Views
- Behavior Definitions
- Behavior Implementation
- Early Numbering
- Validations
- Determinations
- Create-by-Association
- Custom Factory Actions
- UI Annotations
- Service Definition
- Service Binding
- OData-based service consumption
- Fiori Elements
- abapGit

## 👨‍💻 Author

**Sham Patil**

SAP ABAP Developer | RAP | CDS | S/4HANA

GitHub: [patilsham28](https://github.com/patilsham28)

## 📌 Project Status

**Completed**

This repository contains the ABAP development objects for the RAP Sales Order Management application.
