%global srcname pyzabbix
%global commit @COMMIT@

Name:           python-pyzabbix
Version:        1.1.5
Release:        1%{?dist}
Summary:        Py-Zabbix is a Python module for working with the Zabbix API

License:        GPLv2
URL:            https://github.com/adubkov/py-zabbix
Source0:        python-%{srcname}-%{commit}.tar.gz
BuildArch:      noarch

BuildRequires:  python%{python3_pkgversion}-devel
BuildRequires:  python%{python3_pkgversion}-requests
BuildRequires:  python%{python3_pkgversion}-setuptools
BuildRequires:  python%{python3_pkgversion}-mock


%description
%{summary}.


%package -n python%{python3_pkgversion}-%{srcname}
Summary:        PyZabbix is a Python module for working with the Zabbix API
License:        GPLv2
%{?python_provide:%python_provide python%{python3_pkgversion}-%{srcname}}


%description -n python%{python3_pkgversion}-%{srcname}
%{summary}.


%prep
%autosetup -n python-%{srcname}-%{commit}


%build
%py3_build


%install
%py3_install


%check
%{__python3} setup.py test


%files -n python%{python3_pkgversion}-%{srcname}
%doc README.rst
%{python3_sitelib}/%{srcname}
%{python3_sitelib}/%{srcname}-%{version}-py%{python3_version}.egg-info


%changelog
* Mon Dec 16 2019 Nikita Kretov  <kretov995@gmail.com> - 1.1.5-1
- First build
