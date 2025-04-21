// Import required Firebase functions at the top
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getFirestore, collection, getDocs, doc, getDoc } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

// Your existing Firebase config
const firebaseConfig = {
  apiKey: "AIzaSyCqQEBkKrONGJvufR9F-tgU7VUTKqpVy8k",
  authDomain: "rajputji0.firebaseapp.com",
  projectId: "rajputji0",
  storageBucket: "rajputji0.appspot.com",
  messagingSenderId: "1062495598488",
  appId: "1:1062495598488:web:12a7f964ce69d6d2315ded",
  measurementId: "G-P54S8FXF4Y"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// DOM Elements
const startBtn = document.getElementById('startBtn');
const endBtn = document.getElementById('endBtn');
const lectureCodeInput = document.getElementById('lectureCode');
const qrCodeImg = document.getElementById('qrCodeImg');
const timerEl = document.getElementById('timer');
const sessionStatus = document.getElementById('sessionStatus');
const studentCountEl = document.getElementById('studentCount');
const attendanceList = document.getElementById('attendanceList');
const notificationBadge = document.getElementById('notificationBadge');
const bellIcon = document.getElementById('bellIcon');
const notifDropdown = document.getElementById('notifDropdown');
const notifList = document.getElementById('notifList');
const historyBtn = document.getElementById('historyBtn');
const historyDropdown = document.getElementById('historyDropdown');
const historyList = document.getElementById('historyList');
const exportBtn = document.getElementById('exportBtn');
const exportDropdown = document.getElementById('exportDropdown');
const exportCsv = document.getElementById('exportCsv');
const exportPdf = document.getElementById('exportPdf');

// Global Variables
let intervalId, countdown;
let students = [];
let history = {};
let qrInterval;
const validScheduleCodes = ['RCTS6Q', 'IIWFM0', '5L4NMI', '6TZ4XM', 'JZ1SD5'];

// Event Listeners
lectureCodeInput.addEventListener('input', handleLectureCodeInput);
bellIcon.addEventListener('click', toggleNotificationDropdown);
historyBtn.addEventListener('click', toggleHistoryDropdown);
exportBtn.addEventListener('click', toggleExportDropdown);
startBtn.addEventListener('click', startSession);
endBtn.addEventListener('click', endSession);
exportCsv.addEventListener('click', exportToCSV);
exportPdf.addEventListener('click', exportToPDF);

// Initialize demo scan
setTimeout(() => {
  recordAttendance({
    name: 'Quinn Wilson',
    id: 'STU6939',
    time: new Date().toLocaleTimeString()
  });
}, 8000);

// Functions
function handleLectureCodeInput() {
  const code = lectureCodeInput.value.trim();
  startBtn.disabled = !code;
  endBtn.disabled = true;
  students = [];
  updateAttendanceUI();
  updateNotifications();
  updateExports();
}

function toggleNotificationDropdown() {
  notifDropdown.classList.toggle('hidden');
}

function toggleHistoryDropdown() {
  historyDropdown.classList.toggle('hidden');
  renderHistory();
}

function toggleExportDropdown() {
  exportDropdown.classList.toggle('hidden');
}

async function startSession() {
  const code = lectureCodeInput.value.trim();
  if (!code) return;

  // Check if entered code matches any valid schedule code
  if (!validScheduleCodes.includes(code)) {
    alert("Invalid lecture code. Please check and try again.");
    return;
  }

  // If code is valid, start the session
  startBtn.disabled = true;
  endBtn.disabled = false;
  lectureCodeInput.disabled = true;
  sessionStatus.textContent = 'Session Active';
  sessionStatus.classList.replace('inactive', 'active');
  students = [];
  
  updateAttendanceUI();
  updateNotifications();
  updateExports();

  countdown = 5;
  updateQRCode();
  
  qrInterval = setInterval(updateQRCode, 5000);
  intervalId = setInterval(updateTimer, 1000);
}

function endSession() {
  clearInterval(intervalId);
  clearInterval(qrInterval);
  
  const code = lectureCodeInput.value.trim();
  history[code] = students.slice();
  
  lectureCodeInput.disabled = false;
  startBtn.disabled = false;
  endBtn.disabled = true;
  sessionStatus.textContent = 'Session Inactive';
  sessionStatus.classList.replace('active', 'inactive');
  timerEl.textContent = '--s';
  qrCodeImg.src = 'https://via.placeholder.com/300x300?text=QR+Code';
  
  updateExports();
}

function updateTimer() {
  if (countdown > 0) countdown--;
  timerEl.textContent = countdown + 's';
}

function updateQRCode() {
  countdown = 5;
  const seed = Math.random().toString(36).substr(2, 8);
  qrCodeImg.src = `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${encodeURIComponent(lectureCodeInput.value + '-' + seed)}`;
}

function recordAttendance(data) {
  students.push(data);
  updateAttendanceUI();
  updateNotifications();
  updateExports();
  notificationBadge.textContent = students.length;
}

function updateAttendanceUI() {
  studentCountEl.textContent = students.length;
  attendanceList.innerHTML = '';
  
  if (!students.length) {
    attendanceList.innerHTML = '<li>No students have been marked present yet</li>';
    return;
  }

  students.forEach(student => {
    const li = document.createElement('li');
    li.innerHTML = `
      <div class="student-name">${student.name}</div>
      <div class="student-id">${student.id}</div>
      <div class="timestamp">${student.time}</div>
    `;
    attendanceList.appendChild(li);
  });
}

function updateNotifications() {
  notifList.innerHTML = '';
  
  if (!students.length) {
    notifList.innerHTML = '<li>No records yet</li>';
    return;
  }

  students.forEach(student => {
    const li = document.createElement('li');
    li.textContent = `${student.name} - ${student.time}`;
    notifList.appendChild(li);
  });
}

function renderHistory() {
  historyList.innerHTML = '';
  const codes = Object.keys(history);
  
  if (!codes.length) {
    historyList.innerHTML = '<li>No history</li>';
    return;
  }

  codes.forEach(code => {
    const li = document.createElement('li');
    li.textContent = `${code} (${history[code].length} attendees)`;
    historyList.appendChild(li);
  });
}

function updateExports() {
  exportBtn.disabled = students.length === 0;
  if (students.length === 0) exportDropdown.classList.add('hidden');
}

function exportToCSV() {
  let csv = 'Name,ID,Time\n';
  students.forEach(student => {
    csv += `${student.name},${student.id},${student.time}\n`;
  });
  
  const blob = new Blob([csv], { type: 'text/csv' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = `${lectureCodeInput.value.trim()}_attendance.csv`;
  link.click();
  exportDropdown.classList.add('hidden');
}

function exportToPDF() {
  const { jsPDF } = window.jspdf;
  const doc = new jsPDF();
  
  doc.text(`Attendance for ${lectureCodeInput.value.trim()}`, 10, 10);
  let y = 20;
  
  students.forEach(student => {
    doc.text(`${student.name} (${student.id}) at ${student.time}`, 10, y);
    y += 10;
  });
  
  doc.save(`${lectureCodeInput.value.trim()}_attendance.pdf`);
  exportDropdown.classList.add('hidden');
}