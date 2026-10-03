extends Resource
class_name GraphNodeConstants

## НАСТРОЙКИ UI В GRAPH NODE
#Label
const LABEL_HORIZONTAL_ALIGNMENT = HORIZONTAL_ALIGNMENT_CENTER
#SpinBox
const SPINBOX_BASE_STEP : float = 0.01
#TextEdit
const TEXT_FIT_CONTENT_HEIGHT : bool = true
const TEXT_FIT_CONTENT_WIDTH : bool = true
const TEXT_MINIMUM_SIZE_X : int = 150

const ACTIVE_NODE_DATA_NAME  : String  = "ActiveNode" 
const BIG_INSTR_NODE_DATA_NAME : String = "BigInstrNodeData" ## String --- Хранит тип нода, для быстрой выпечки

const CENTRAL_DATA_NAME : String  = "CentralPortsData" ## Array[Metadata...]

const LEFT_PORTS_DATA_NAME  : String  = "LeftPortsData" ## Array[Metadata...]
const RIGHT_PORTS_DATA_NAME  : String  = "RightPortsData" ## Array[Metadata...]

const PORT_VALUE_FREE : String = "PortFree"
const PORT_VALUE_OCCUPIED : String = "PortOccupied"
