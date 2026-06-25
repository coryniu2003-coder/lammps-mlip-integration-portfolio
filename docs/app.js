const models = [
  { id: "mace", name: "MACE MP0", env: "mace-env", status: "configuration", note: "Equivariant graph neural network" },
  { id: "chgnet", name: "CHGNet", env: "base", status: "configuration", note: "Charge-informed graph network" },
  { id: "matgl", name: "MatGL M3GNet", env: "mlff_matgl_sevenn", status: "tested", note: "Graph neural network potential" },
  { id: "sevennet", name: "SevenNet", env: "mlff_matgl_sevenn", status: "tested", note: "Equivariant neural network" },
  { id: "mattersim", name: "MatterSim", env: "mlff_mattersim_orb", status: "tested", note: "Pretrained materials model" },
  { id: "orb", name: "ORB", env: "mlff_mattersim_orb", status: "tested", note: "Graph-based force model" },
  { id: "eqv2m", name: "EquiformerV2-M", env: "mlff_fairchem", status: "configuration", note: "Equivariant transformer" }
];
const grid = document.querySelector("#model-grid");
const select = document.querySelector("#model-select");
models.forEach((model) => {
  const card = document.createElement("article"); card.className = "model-card"; card.dataset.status = model.status;
  card.innerHTML = `<span class="status">${model.status === "tested" ? "tested locally" : "configuration example"}</span><h3>${model.name}</h3><p>${model.note}</p><p><code>${model.env}</code></p>`;
  grid.appendChild(card);
  const option = document.createElement("option"); option.value = model.id; option.textContent = model.name; if (model.id === "matgl") option.selected = true; select.appendChild(option);
});
const fields = { model: select, temperature: document.querySelector("#temperature"), steps: document.querySelector("#steps"), elements: document.querySelector("#elements"), structure: document.querySelector("#structure") };
const output = document.querySelector("#command-output"); const doctorModel = document.querySelector("#doctor-model");
function shellQuote(value) { return `'${String(value).replaceAll("'", "'\\''")}'`; }
function updateCommand() {
  output.textContent = ["bash scripts/run_demo.sh", `  --model ${fields.model.value}`, `  --structure ${shellQuote(fields.structure.value)}`, `  --elements ${shellQuote(fields.elements.value)}`, `  --temperature ${fields.temperature.value}`, `  --steps ${fields.steps.value}`].join(" \\\n");
  doctorModel.textContent = fields.model.value;
}
Object.values(fields).forEach((field) => field.addEventListener("input", updateCommand)); updateCommand();
document.querySelector("#copy-command").addEventListener("click", async (event) => {
  try { await navigator.clipboard.writeText(output.textContent); event.currentTarget.textContent = "Copied"; window.setTimeout(() => { event.currentTarget.textContent = "Copy command"; }, 1400); }
  catch { event.currentTarget.textContent = "Select and copy"; }
});
