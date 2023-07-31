const fragment = new DocumentFragment();
const api = "http://127.0.0.1:3000/api/v1/";
let saved_data = null;

document.addEventListener('DOMContentLoaded', function() {
  fetch(api + "exams")
    .then((response) => response.json())
    .then((data) => {
      saved_data = data;

      displayData(data);
    })
    .catch(function (error) {
      console.log(error);
    });
});

function getExamData(exam_id) {
  modal = document.getElementById("modal");
  cleanModal();
  addLoading(document.getElementById('loading-tests'));
  modal.showModal();

  fetch(api + `exams/${exam_id}`)
    .then((response) => response.json())
    .then((data) => {
      displayPatientData(data);
      displayDoctorData(data.doctor);
      displayTestsData(data.tests, data.result_date);
      removeLoading(document.getElementById('loading-tests'));
    });
}

function addLoading(element){
  element.classList.remove('hidden')
  element.classList.add('block');
}

function removeLoading(element){
  element.classList.remove('block')
  element.classList.add('hidden');
}

function displayPatientData(data) {
  const patientDataDiv = document.getElementById('patient-data');
  patientDataDiv.innerHTML = `
    <p>CPF: ${data.cpf}</p>
    <p>Nome: ${data.name}</p>
    <p>Email: ${data.email}</p>
    <p>Data de Nascimento: ${data.birthday}</p>
    <!-- Add other patient data here -->
  `;
}

function displayDoctorData(data) {
  const doctorDataDiv = document.getElementById("doctor-data");
  doctorDataDiv.innerHTML = `
      <p>CRM: ${data.crm}</p>
      <p>CRM Estado: ${data.crm_state}</p>
      <p>Nome: ${data.name}</p>
      <p>Email: ${data.email}</p>
      <!-- Add other doctor data here -->
    `;
}

function displayTestsData(tests, exam_date) {
  const testsTableBody = document.getElementById('tests-table-body');

  tests.forEach((test) => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${test.type}</td>
      <td>${exam_date}</td>
      <td>${test.limits}</td>
      <td>${test.result}</td>
    `;
    testsTableBody.appendChild(row);
  });
}

function cleanModal(){
  const doctorDataDiv = document.getElementById("doctor-data");
  const testsTableBody = document.getElementById('tests-table-body');
  const patientDataDiv = document.getElementById('patient-data');
  doctorDataDiv.innerHTML = '';
  testsTableBody.innerHTML = '';
  patientDataDiv.innerHTML = '';
}



function displayData(data){
  const tableBody = document.getElementById("table-body");
  tableBody.innerHTML='';


  data.sort(function (a, b) {
    return new Date(b.date) - new Date(a.date);
  });

  data.forEach((item) => {
    const row = document.createElement("tr");

    row.innerHTML = `
        <td>${item.patient_name}</td>
        <td>${item.cpf}</td>
        <td>${item.patient_birthdate}</td>
        <td>${item.doctor_name}</td>
        <td>${item.date}</td>
        <td>${item.token}</td>
        <td>
          <a href="#" onclick="getExamData(${item.exam_id})">
            <i class="fa-solid fa-eye"></i>
          </a>
        </td>
      `;

    tableBody.appendChild(row);
  });
}


function autoSearch(){
  const searchInput = document.getElementById('search-input');
  
  if(searchInput.value.length>2){
    search();
  }else{
    displayData(saved_data);
  }
}

function search(){
  const searchInput = document.getElementById('search-input').value.toLowerCase().trim();
  
  const filteredData = saved_data.filter((item) => {
    const nameMatch = item.patient_name.toLowerCase().includes(searchInput);
    const doctorNameMatch = item.doctor_name.toLowerCase().includes(searchInput);
    const tokenMatch = item.token.toLowerCase().includes(searchInput);
    const cpfMatch = item.cpf.toLowerCase().includes(searchInput);
    return nameMatch || doctorNameMatch || tokenMatch || cpfMatch;
  });

  displayData(filteredData);
}


function uploadFile() {
  const fileInput = document.getElementById('fileInput');
  const file = fileInput.files[0];

  if (file) {
    const formData = new FormData();
    formData.append('file', file);

    fetch(api+'async_import', {
      method: 'POST',
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
      })
      .catch((error) => {
        console.error('Error:', error);
      });
  } else {
    console.error('No file selected');
  }
}