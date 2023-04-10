from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf8") as fh:
    long_description = fh.read()

setup(
    name="my_package",
    version="0.0.1",
    author="Jussi Vatjus-Anttila",
    author_email="jussiva@gmail.com",
    description="A small example package",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/jupe/template_python",
    project_urls={
        "Bug Tracker": "https://github.com/jupe/template_python/issues"
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    extras_require={
        "dev": [
            "pytest~=7.3.0",
            "pytest-cov~=4.0.0",
            "pytest-mock~=3.10.0",
            "pytest-xdist~=3.2.1",
            "pytest-randomly~=3.12.0",
            "pytest-timeout~=2.1.0",
            "flake8>=5.0.4"
        ]
    },
    package_dir={"": "src"},
    packages=find_packages(where="src"),
    python_requires=">=3.7"
)
